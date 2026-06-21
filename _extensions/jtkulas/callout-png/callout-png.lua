-- callout-png.lua
local meta = {}

function Meta(m)
  meta = m
  return m
end

local function darken_color(hex, percent)
  hex = hex:gsub("#", "")
  local r = tonumber(hex:sub(1,2), 16) or 255
  local g = tonumber(hex:sub(3,4), 16) or 255
  local b = tonumber(hex:sub(5,6), 16) or 255
  r = math.floor(r * (1 - percent))
  g = math.floor(g * (1 - percent))
  b = math.floor(b * (1 - percent))
  return string.format("#%02x%02x%02x", r, g, b)
end

local function get_meta(key, fallback)
  if meta[key] then
    return pandoc.utils.stringify(meta[key])
  end
  return fallback
end

local function is_url(s)
  return s:match("^https?://") ~= nil
end

local function is_html_output()
  return quarto.doc.is_format("html") or FORMAT:match("html") or FORMAT == "revealjs"
end

local function get_image_width_em(image_height_str)
  local h = tonumber(image_height_str:match("(%d+%.?%d*)") or "4.8")
  local width_em
  if h >= 7.5 then
    width_em = h * 1.12
  elseif h >= 5 then
    width_em = h * 1.40
  else
    width_em = h * 1.75
  end
  if h > 6.5 then
    width_em = width_em * 1.55
  elseif h > 4.5 then
    width_em = width_em * 1.20
  end
  return math.max(2.8, math.min(width_em, 21))
end

local function file_exists(path)
  local f = io.open(path, "r")
  if f then
    io.close(f)
    return true
  end
  return false
end

local function get_ext_dir()
  -- Try to get from quarto if available
  if quarto and quarto.extension and quarto.extension.directory then
    return quarto.extension.directory()
  end
  
  -- Fallback: use debug.getinfo to find the script location
  local script_path = debug.getinfo(1).source
  if script_path:sub(1, 1) == "@" then
    script_path = script_path:sub(2)
  end
  
  -- Extract directory from script path
  local dir = script_path:match("(.*)[/\\]")
  return dir or "."
end

local function normalize_path(path)
  -- Convert backslashes to forward slashes for consistency
  return path:gsub("\\", "/")
end

local function resolve_image_for_format(image_url, format)
  -- If it's a URL, return as-is
  if is_url(image_url) then
    return image_url
  end
  
  -- Check if file exists relative to current directory
  if file_exists(image_url) then
    return normalize_path(image_url)
  end
  
  -- Try to find in extension directory
  local ext_dir = get_ext_dir()
  local filename = image_url:match("([^/\\]+)$")
  local ext_image_path = ext_dir .. "/images/" .. filename
  
  if not file_exists(ext_image_path) then
    -- File not found, return original normalized path
    return normalize_path(image_url)
  end
  
  -- File found in extension directory
  if format == "latex" then
    -- LaTeX can handle absolute paths with forward slashes
    return normalize_path(ext_image_path)
  else
    -- HTML, RevealJS, Typst, PDF: use relative path from extension dir
    -- Return path relative to extension images folder
    return "_extensions/jtkulas/callout-png/images/" .. filename
  end
end

return {
  { Meta = Meta },

  {
    Div = function(div)
      if not div.classes:includes("callout-png") then
        return div
      end

      local title       = pandoc.utils.stringify(div.attributes.title or "Pinktacular Callout")
      local color       = pandoc.utils.stringify(div.attributes.color or "#ff99ff")
      local image_url   = pandoc.utils.stringify(div.attributes.image or "pink-panther.png")
      local image_height = pandoc.utils.stringify(div.attributes["image-height"] or "4.8em")
      local header_vpad = pandoc.utils.stringify(div.attributes["header-vpad"] or "0em")

      if tonumber(header_vpad) and tonumber(header_vpad) < 0 then
        header_vpad = "0em"
      end

      local mainfont    = get_meta("mainfont", "inherit")
      local base_size   = get_meta("fontsize", "1.15em")
      local border_color = darken_color(color, 0.08)

      local function protect_tex_names(str)
        if not str then return "" end
        return str:gsub("LaTeX", "\\textnormal{LaTeX}")
                  :gsub("TeX",   "\\textnormal{TeX}")
      end
      title = protect_tex_names(title)

      if is_html_output() then
        local resolved_image = resolve_image_for_format(image_url, "html")
        
        local icon_html = string.format(
          '<img src="%s" class="callout-png-icon" style="height: %s; width: auto; max-width: 100%%; margin: 0 0.6em 0 0; vertical-align: middle; object-fit: contain;">',
          resolved_image, image_height
        )

        local header = pandoc.Div({
          pandoc.RawInline("html", icon_html),
          pandoc.Header(3, pandoc.Str(title), {
            style = "margin: 0; padding: 0 0.6em; flex: 1; line-height: 1.15;"
          })
        }, {
          class = "callout-png-header",
          style = "background-color: " .. color .. "; padding: " .. header_vpad .. " 1.2em; " ..
                  "display: flex; align-items: center; font-family: " .. mainfont .. "; font-size: " .. base_size .. ";"
        })

        local body = pandoc.Div(div.content, {
          class = "callout-png-body",
          style = "padding: 1.4em 1.6em; font-size: 1.15em; line-height: 1.7;"
        })

        return pandoc.Div({header, body}, {
          class = "callout-png",
          style = "border: 1px solid #e5e5e5; border-left: 0.45rem solid " .. border_color .. 
                  "; border-radius: 0.4rem; margin: 1.8em 0; overflow: hidden; " ..
                  "background-color: #ffffff; box-shadow: 0 5px 18px rgba(0,0,0,0.09);"
        })

      elseif FORMAT == "latex" then
        quarto.doc.include_text("in-header", "\\usepackage{tcolorbox}\n\\tcbuselibrary{skins}")

        local resolved_image = resolve_image_for_format(image_url, "latex")
        local icon_latex = string.format("\\includegraphics[height=%s]{%s}", image_height, resolved_image)

        local color_name  = "calloutcolor" .. tostring(os.time() + math.random(10000))
        local border_name = "calloutborder" .. tostring(os.time() + math.random(10000))

        local width_em = get_image_width_em(image_height)
        local hspace_val = string.format("%.1fem", 0.6 + (width_em * 0.72))

        local latex_code = string.format([[
\definecolor{%s}{HTML}{%s}
\definecolor{%s}{HTML}{%s}

\noindent\begin{minipage}{\textwidth}
  \colorbox{%s}{
    \parbox{\dimexpr\textwidth-1.2em\relax}{
      \vspace{%s}
      \noindent\begin{tabular}{@{}l l@{}}
        \hspace{1.2em}\raisebox{-0.35\height}{\makebox[0pt][l]{%s}} & 
        \hspace{%s}\raisebox{-0.35\height}{\large\bfseries %s} \\
      \end{tabular}
      \vspace{%s}
    }
  }
\end{minipage}

\vspace{-0.85em}
\noindent\begin{minipage}{\textwidth}
\begin{tcolorbox}[
  colback=white,
  colframe=%s,
  sharp corners,
  boxrule=0.8pt,
  left=1.2em, right=1.2em,
  top=0.6em, bottom=1.2em,
  width=\textwidth,
  boxsep=0pt,
  arc=4pt
]
]],
          color_name, color:gsub("#",""),
          border_name, border_color:gsub("#",""),
          color_name,
          header_vpad,
          icon_latex,
          hspace_val,
          title,
          header_vpad,
          border_name
        )

        -- Output header + body content + closing
        local blocks = {
          pandoc.RawBlock("latex", latex_code)
        }
        for _, b in ipairs(div.content) do
          table.insert(blocks, b)
        end
        table.insert(blocks, pandoc.RawBlock("latex", "\\end{tcolorbox}\n\\end{minipage}"))

        return pandoc.Div(blocks)

      elseif FORMAT == "typst" then
        local resolved_image = resolve_image_for_format(image_url, "typst")
        
        local icon_typst
        if is_url(resolved_image) then
          icon_typst = '🖼️'
        else
          icon_typst = '#box(height: ' .. image_height .. ', align(horizon)[#image("' .. 
                       resolved_image .. '", height: ' .. image_height .. ')])'
        end

        local vpad = header_vpad

        local header_height = image_height
        if vpad ~= "0em" then
          header_height = image_height .. " + 2*" .. vpad
        end

        local header_part = '#box(height: ' .. header_height .. ', inset: (y: ' .. vpad .. '), ' ..
                            'align(horizon)[' .. icon_typst .. '#h(0.8em)' .. title .. '])'

        -- Best method: Let Pandoc convert the content to Typst
        local body_blocks = pandoc.write(pandoc.Pandoc(div.content), "typst")

        local typst_code = "#callout(\n" ..
          "  title: [" .. header_part .. "],\n" ..
          '  background_color: rgb("' .. color .. '"),\n' ..
          '  icon_color: rgb("' .. border_color .. '"),\n' ..
          '  body_background_color: rgb("#ffffff"),\n' ..
          "  body: [" .. body_blocks .. "]\n" ..
          ")"

        return pandoc.RawBlock("typst", typst_code)
      end

      return div
    end
  }
}
