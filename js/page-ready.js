/**
 * Reveal page content (html.loaded) and hide preloader.
 * Required because critical CSS hides .page-wrapper until html has .loaded.
 */
(function () {
	"use strict";

	var revealed = false;

	function reveal() {
		if (revealed) return;
		revealed = true;
		document.documentElement.classList.add("loaded");
		var container = document.getElementById("container-preloader");
		if (container) container.classList.add("loaded");
		var preloader = document.getElementById("preloader");
		if (preloader) {
			window.setTimeout(function () {
				preloader.style.display = "none";
			}, 1100);
		}
	}

	if (!document.getElementById("preloader")) {
		reveal();
		return;
	}

	if (document.readyState === "complete") {
		reveal();
	} else {
		window.addEventListener("load", reveal, { once: true });
	}

	/* Never leave the page hidden if load stalls */
	window.setTimeout(reveal, 4000);
})();
