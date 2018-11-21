// import { AUTHENTICITY_TOKEN } from "../from_rails/constants"

console.log("Hello from Question Show!");

document.querySelectorAll(`.fetch-delete`).forEach(node => {
  node.addEventListener("click", event => {
    event.preventDefault();
    // With stopPropagation, you will stop the Rails Javascript from executing, such as `method: :delete, and data: { confirm: "Are you positive?" } 
    // event.stopPropagation();

    const { currentTarget } = event;

    // Simulate a real form, instead of using JSON.
    // Use a FormData object.
    // Use the .set() method to build up the data FormData object from scratch.
    // Then put the new formData instance in the fetch body.


    const formData = new FormData();
    formData.set("authenticity_token", currentTarget.dataset.authenticityToken);

    fetch(currentTarget.href, {
      method: "DELETE",
      credentials: "same-origin",
      body: formData
    }).then(() => {
      currentTarget.closest("li").remove()})
  });
})
