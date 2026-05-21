/*! loadCSS rel=preload polyfill — Filament Group, MIT */
(function (w) {
  "use strict";
  if (!w.loadCSS) {
    w.loadCSS = function () {};
  }
  var rp = w.loadCSS.relpreload = w.loadCSS.relpreload || {};
  rp.support = function () {
    try {
      return w.document.createElement("link").relList.supports("preload");
    } catch (e) {
      return false;
    }
  };
  rp.poly = function () {
    var links = w.document.getElementsByTagName("link");
    for (var i = 0; i < links.length; i++) {
      var link = links[i];
      if (
        link.rel === "preload" &&
        link.getAttribute("as") === "style" &&
        !link.getAttribute("data-loadcss")
      ) {
        link.setAttribute("data-loadcss", "true");
        var href = link.getAttribute("href");
        var sheet = link.cloneNode();
        sheet.setAttribute("onload", null);
        sheet.rel = "stylesheet";
        sheet.href = href;
        link.parentNode.insertBefore(sheet, link.nextSibling);
      }
    }
  };
  if (!rp.support()) {
    rp.poly();
    var run = w.setInterval(rp.poly, 300);
    if (w.addEventListener) {
      w.addEventListener("load", function () {
        rp.poly();
        w.clearInterval(run);
      });
    }
  }
})(typeof global !== "undefined" ? global : this);
