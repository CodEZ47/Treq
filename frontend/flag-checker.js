document.getElementById("flagForm").addEventListener("submit", function (e) {
  e.preventDefault();

  const flagsInput = document.getElementById("flagsInput").value;
  const flags = flagsInput.split("\n").filter(f => f.trim() !== "");

  const results = [];

  const promises = flags.map((flag) =>
    fetch("/validate", {
      method: "POST",
      body: flag,
    }).then((res) => res.text()),
  );

  Promise.all(promises).then((results) => {
    document.getElementById("result").textContent = results.join("\n");
  });
});
