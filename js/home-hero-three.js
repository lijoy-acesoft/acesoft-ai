/**
 * Homepage hero WebGL — loaded only when hero is visible (see index.html loader).
 */
(function (global) {
  "use strict";

  function prefersReducedMotion() {
    return global.matchMedia("(prefers-reduced-motion: reduce)").matches;
  }

  function isDesktop() {
    return global.innerWidth >= 992;
  }

  function initBanner(section, canvas) {
    var THREE = global.THREE;
    var reduced = prefersReducedMotion();
    var mobile = global.innerWidth < 768;
    var renderer = new THREE.WebGLRenderer({ canvas: canvas, alpha: true, antialias: !mobile });
    renderer.setPixelRatio(Math.min(global.devicePixelRatio, mobile ? 1.25 : 1.75));
    renderer.setSize(section.clientWidth, section.clientHeight, false);

    var scene = new THREE.Scene();
    var camera = new THREE.PerspectiveCamera(50, section.clientWidth / section.clientHeight, 0.1, 500);
    camera.position.z = 38;

    var clock = new THREE.Clock();
    var mx = 0;
    var my = 0;
    var rafId = 0;
    var running = false;
    var N = mobile ? 500 : 1200;
    var pGeo = new THREE.BufferGeometry();
    var pPos = new Float32Array(N * 3);
    for (var i = 0; i < N; i++) {
      pPos[i * 3] = (Math.random() - 0.5) * 80;
      pPos[i * 3 + 1] = (Math.random() - 0.5) * 40;
      pPos[i * 3 + 2] = (Math.random() - 0.5) * 35;
    }
    pGeo.setAttribute("position", new THREE.BufferAttribute(pPos, 3));
    var pts = new THREE.Points(
      pGeo,
      new THREE.PointsMaterial({
        color: 0x4477cc,
        size: 0.09,
        transparent: true,
        opacity: 0.6,
        blending: THREE.AdditiveBlending,
        depthWrite: false
      })
    );
    scene.add(pts);

    var gSize = 60;
    var gDivs = 12;
    var gridGeo = new THREE.BufferGeometry();
    var gVerts = [];
    var step = gSize / gDivs;
    for (var g = 0; g <= gDivs; g++) {
      var v = -gSize / 2 + g * step;
      gVerts.push(-gSize / 2, -14, v, gSize / 2, -14, v);
      gVerts.push(v, -14, -gSize / 2, v, -14, gSize / 2);
    }
    gridGeo.setAttribute("position", new THREE.BufferAttribute(new Float32Array(gVerts), 3));
    scene.add(
      new THREE.LineSegments(
        gridGeo,
        new THREE.LineBasicMaterial({
          color: 0x1a3a7a,
          transparent: true,
          opacity: 0.35,
          blending: THREE.AdditiveBlending,
          depthWrite: false
        })
      )
    );

    function onResize() {
      camera.aspect = section.clientWidth / section.clientHeight;
      camera.updateProjectionMatrix();
      renderer.setSize(section.clientWidth, section.clientHeight, false);
    }

    function frame() {
      var t = clock.getElapsedTime();
      pts.rotation.y = t * 0.025;
      pts.rotation.x = Math.sin(t * 0.18) * 0.04;
      camera.position.x += (mx * 4 - camera.position.x) * 0.035;
      camera.position.y += (-my * 2.5 - camera.position.y) * 0.035;
      camera.lookAt(0, 0, 0);
      renderer.render(scene, camera);
      if (running) rafId = global.requestAnimationFrame(frame);
    }

    function start() {
      if (running) return;
      running = true;
      frame();
    }

    function stop() {
      running = false;
      if (rafId) global.cancelAnimationFrame(rafId);
    }

    section.addEventListener(
      "mousemove",
      function (e) {
        var r = section.getBoundingClientRect();
        mx = ((e.clientX - r.left) / r.width) * 2 - 1;
        my = ((e.clientY - r.top) / r.height) * 2 - 1;
      },
      { passive: true }
    );

    global.addEventListener("resize", onResize, { passive: true });

    if (!reduced) start();
    else renderer.render(scene, camera);

    return {
      start: start,
      stop: stop,
      dispose: function () {
        stop();
        global.removeEventListener("resize", onResize);
        renderer.dispose();
        pGeo.dispose();
        gridGeo.dispose();
      }
    };
  }

  function initOrb(wrap, canvas) {
    var THREE = global.THREE;
    var reduced = prefersReducedMotion();
    var W = 260;
    var H = 260;
    var renderer = new THREE.WebGLRenderer({ canvas: canvas, alpha: true, antialias: true });
    renderer.setPixelRatio(Math.min(global.devicePixelRatio, 1.75));
    renderer.setSize(W, H, false);

    var scene = new THREE.Scene();
    var camera = new THREE.PerspectiveCamera(48, 1, 0.1, 200);
    camera.position.z = 12;
    var clock = new THREE.Clock();
    var mx = 0;
    var my = 0;
    var rafId = 0;
    var running = false;

    var core = new THREE.Group();
    core.add(
      new THREE.Mesh(
        new THREE.IcosahedronGeometry(2.6, 3),
        new THREE.MeshBasicMaterial({ color: 0x08163a, transparent: true, opacity: 0.95 })
      )
    );
    core.add(
      new THREE.Mesh(
        new THREE.IcosahedronGeometry(2.65, 1),
        new THREE.MeshBasicMaterial({ color: 0x3a7fff, wireframe: true, transparent: true, opacity: 0.6 })
      )
    );
    scene.add(core);

    var nodeN = 24;
    var nPos = [];
    for (var n = 0; n < nodeN; n++) {
      var theta = Math.random() * Math.PI * 2;
      var phi = Math.acos(2 * Math.random() - 1);
      var r = 7 * (0.5 + Math.random() * 0.5);
      nPos.push(
        new THREE.Vector3(
          r * Math.sin(phi) * Math.cos(theta),
          r * Math.sin(phi) * Math.sin(theta),
          r * Math.cos(phi)
        )
      );
    }
    var ndGeo = new THREE.BufferGeometry();
    var ndPos = new Float32Array(nodeN * 3);
    nPos.forEach(function (p, i) {
      ndPos[i * 3] = p.x;
      ndPos[i * 3 + 1] = p.y;
      ndPos[i * 3 + 2] = p.z;
    });
    ndGeo.setAttribute("position", new THREE.BufferAttribute(ndPos, 3));
    scene.add(
      new THREE.Points(
        ndGeo,
        new THREE.PointsMaterial({
          color: 0x88ccff,
          size: 0.18,
          transparent: true,
          opacity: 0.9,
          blending: THREE.AdditiveBlending,
          depthWrite: false
        })
      )
    );

    function frame() {
      var t = clock.getElapsedTime();
      core.rotation.y = t * 0.2;
      core.rotation.x = Math.sin(t * 0.28) * 0.1;
      camera.position.x += (mx * 2.5 - camera.position.x) * 0.04;
      camera.position.y += (-my * 1.8 - camera.position.y) * 0.04;
      camera.lookAt(0, 0, 0);
      renderer.render(scene, camera);
      if (running) rafId = global.requestAnimationFrame(frame);
    }

    function start() {
      if (running) return;
      running = true;
      frame();
    }

    function stop() {
      running = false;
      if (rafId) global.cancelAnimationFrame(rafId);
    }

    wrap.addEventListener(
      "mousemove",
      function (e) {
        var r = wrap.getBoundingClientRect();
        mx = ((e.clientX - r.left) / r.width) * 2 - 1;
        my = ((e.clientY - r.top) / r.height) * 2 - 1;
      },
      { passive: true }
    );

    if (!reduced) start();
    else renderer.render(scene, camera);

    return {
      start: start,
      stop: stop,
      dispose: function () {
        stop();
        renderer.dispose();
        ndGeo.dispose();
      }
    };
  }

  global.AcesoftHomeHero = {
    mount: function () {
      if (!global.THREE || prefersReducedMotion() || !isDesktop()) return null;

      var section = document.getElementById("acesoftAIHero");
      var bannerCanvas = document.getElementById("ai-banner-canvas");
      var orbCanvas = document.getElementById("ai-orb-canvas");
      var orbWrap = document.getElementById("aiOrbWrap");
      if (!section || !bannerCanvas) return null;

      var scenes = [];
      scenes.push(initBanner(section, bannerCanvas));
      if (orbCanvas && orbWrap && global.innerWidth >= 1200) {
        scenes.push(initOrb(orbWrap, orbCanvas));
      }

      return {
        start: function () {
          scenes.forEach(function (s) {
            s.start();
          });
        },
        stop: function () {
          scenes.forEach(function (s) {
            s.stop();
          });
        },
        dispose: function () {
          scenes.forEach(function (s) {
            s.dispose();
          });
        }
      };
    }
  };
})(window);
