% ---------------------------------------------------------------------------
% Identifying the class by explaining its name and what version of LateX
% it requires.
% ---------------------------------------------------------------------------
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{myColourChangingArticle}[2020/03/25 Example LaTeX class for colour themes]

% ---------------------------------------------------------------------------
% Loading the article class as a base.
% With a .cls class file, you would be able to define a whole new document
% structure. But here we just want to extend article with custom addons.
% ---------------------------------------------------------------------------
\LoadClass[]{article}

% ---------------------------------------------------------------------------
% With RequriePackage, we tell the compiler that we want to use xcolor.
% This is basically a different version of the \usepackage command
% which you probably already knew.
% ---------------------------------------------------------------------------
\RequirePackage{xcolor}

% ---------------------------------------------------------------------------
% This is just because I don't want indent.
% ---------------------------------------------------------------------------
\setlength\parindent{0pt}


% ---------------------------------------------------------------------------
% Here, we define a few colours which are available to any document,
% regardless often the chosen colour option.
% You can use different colour codings, such as rgb and HTML.
% But with \colorlet{name}{colour} you can also define alternative names
% for existing colour names, or 'save' reduced opacity versions (black!20)
% which can now be called with a dedicated name.
%% ---------------------------------------------------------------------------
\definecolor{headercolour}{rgb}{0.25,0.25,0.25}
\definecolor{mypurple}{HTML}{9C27B0}
\definecolor{myblue}{HTML}{2196F3}

% ---------------------------------------------------------------------------
% Defining the 'blue' option by first defining the colours, then
% assigning them to the general colour names using \colorlet.
% In the main, where 'customcolour' or 'alternativecolour' are used
% changing options will cause a colour change because the red option,
% for example, defines them differently (customcolour is red, not blue)
% ---------------------------------------------------------------------------
\DeclareOption{blue}{
\definecolor{customblue}{HTML}{5499C7}
\definecolor{customgrey}{HTML}{CFCFCF}
\colorlet{customlight}{black!10}

\colorlet{customcolour}{customblue}
\colorlet{alternativecolour}{customgrey}
}

% ---------------------------------------------------------------------------
\DeclareOption{red}{
\definecolor{customred}{HTML}{DD5E53}
\definecolor{customgrey}{HTML}{CFCFCF}
\colorlet{customlight}{black!10}

\colorlet{customcolour}{customred}
\colorlet{alternativecolour}{customgrey}
}

% ---------------------------------------------------------------------------
% At the end, we need to pass the options to the article class they are
% meant to extend. If we forget to add this, nothing will happen!
% ---------------------------------------------------------------------------
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{article}}
\ProcessOptions\relax


