(() => {
  function attachThreshold() {
    const slider = document.getElementById("cooccurrence-threshold");
    const network = document.querySelector(".forceNetwork");
    if (!slider || !network || network.dataset.thresholdReady === "true") return false;

    const links = Array.from(network.querySelectorAll("line.link"));
    const nodes = Array.from(network.querySelectorAll("g.node"));
    if (links.length === 0) return false;

    const value = document.getElementById("cooccurrence-threshold-value");
    const count = document.getElementById("cooccurrence-link-count");
    const nodeName = (reference) => {
      if (typeof reference === "object") return reference.name;
      return nodes[reference]?.__data__?.name;
    };
    const update = () => {
      const minimum = Number(slider.value);
      let visible = 0;
      const connected = new Set();
      for (const link of links) {
        const edge = link.__data__;
        const show = Number(edge.value) >= minimum;
        link.style.display = show ? "" : "none";
        if (show) {
          visible++;
          connected.add(nodeName(edge.source));
          connected.add(nodeName(edge.target));
        }
      }
      for (const node of nodes) {
        node.style.display = connected.has(node.__data__.name) ? "" : "none";
      }
      value.textContent = String(minimum);
      count.textContent = `${visible} links · ${connected.size} tools`;
    };

    slider.addEventListener("input", update);
    network.dataset.thresholdReady = "true";
    update();
    return true;
  }

  let attempts = 0;
  const timer = window.setInterval(() => {
    attempts++;
    if (attachThreshold() || attempts >= 80) window.clearInterval(timer);
  }, 250);
})();
