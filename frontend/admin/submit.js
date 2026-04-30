document
  .getElementById("adminLoginForm")
  .addEventListener("submit", function (e) {
    e.preventDefault();

    const username = document.getElementById("username").value;
    const password = document.getElementById("password").value;

    //Send to the backend

    fetch("/admin/login", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify({ username, password }),
    })
      .then((res) => res.text())
      .then((data) => {
        document.getElementById("result").textContent = data;
      })
      .catch((err) => console.error(err));
  });

document.getElementById("protocol").textContent =
  "You're connected via " + window.location.protocol;
