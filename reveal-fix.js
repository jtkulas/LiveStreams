// reveal-fix.js
document.addEventListener("DOMContentLoaded", function() {
  // Find the title slide background
  var bg = document.querySelector('.slide-background-content[style*="NUX_Octodex.gif"]');
  if (bg) {
    bg.style.backgroundPosition = "60% right";
    bg.style.backgroundRepeat = "no-repeat";
    bg.style.backgroundSize = "cover";
  }
});