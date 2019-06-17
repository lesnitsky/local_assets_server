var counter = 0;
var counterNode = document.querySelector("#counter");

window.increment = function increment() {
  counterNode.textContent = counter++;
};
