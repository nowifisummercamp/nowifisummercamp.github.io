// Declare breakpoint
var breakpoint = 800;

// Targeting toggle button
var toggle = document.getElementById("main-menu-toggle");

// Targeting main menu
var menu = document.getElementById("main-menu");

// Toggle function
function menuToggle() {

  // Show main menu on big screen
  if (window.matchMedia("(min-width:" + breakpoint +"px)").matches) {
    menu.classList.remove("is-hidden");
  } else {
    menu.classList.add("is-hidden");
  }

  // Togglemain-menu on click
  toggle.onclick=function(e){
    e.preventDefault();
    menu.classList.toggle('is-hidden');
  };
}

menuToggle();

// Reload function on resize
window.addEventListener('resize', menuToggle);
