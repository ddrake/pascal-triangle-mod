// Generated by CoffeeScript 1.4.0
(function() {
  var add_swatches, buildTriangle, calcAreas, canv, canvHeight, canvWidth, clear, ctx, d1, d2, displayAreas, draw_hexagon, draw_hexagons, draw_row, getMousePos, getNK, getValue, hexPixels, makeRow, modAreas, modBase, modColors, nCk, refresh, rowCount, setLayout, testPoint, tri;

  canvWidth = null;

  canvHeight = null;

  rowCount = null;

  hexPixels = null;

  d1 = null;

  d2 = null;

  modBase = null;

  modColors = ['#fff', '#00f', '#0f0', '#f00', '#099', '#909', '#eb2', '#0a1', '#e7e', '#7ee', '#fe1', '#f1a', '#b93'];

  tri = null;

  modAreas = [];

  canv = document.getElementById('canv');

  ctx = canv.getContext("2d");

  setLayout = function(e) {
    hexPixels = Math.floor(canvWidth / (rowCount + 1));
    d1 = hexPixels / 2;
    d2 = d1 / Math.sqrt(3.0);
    canvHeight = canvWidth * Math.sqrt(3) / 2 + d2;
    canv.width = canvWidth;
    return canv.height = canvHeight;
  };

  clear = function() {
    ctx.fillStyle = "#000";
    ctx.fillRect(0, 0, canv.width, canv.height);
    return ctx.fillStyle = "#fff";
  };

  getMousePos = function(canvas, evt) {
    var rect;
    rect = canvas.getBoundingClientRect();
    return {
      x: evt.clientX - rect.left,
      y: evt.clientY - rect.top
    };
  };

  canv.addEventListener('mousemove', function(evt) {
    var mousePos, val;
    mousePos = getMousePos(canv, evt);
    val = getValue(mousePos);
    return $("#val").html(val);
  }, false);

  nCk = function(n, k) {
    var den, kp, num, _i, _j, _ref, _results, _results1;
    if (n === 0 || k === 0 || k === n) {
      return 1;
    } else {
      kp = k > n / 2 ? n - k : k;
      num = (function() {
        _results = [];
        for (var _i = _ref = n - kp + 1; _ref <= n ? _i <= n : _i >= n; _ref <= n ? _i++ : _i--){ _results.push(_i); }
        return _results;
      }).apply(this).reduce(function(x, y) {
        return x * y;
      });
      den = (function() {
        _results1 = [];
        for (var _j = 1; 1 <= kp ? _j <= kp : _j >= kp; 1 <= kp ? _j++ : _j--){ _results1.push(_j); }
        return _results1;
      }).apply(this).reduce(function(x, y) {
        return x * y;
      });
      return num / den;
    }
  };

  getNK = function(x, y) {
    var kapr, ku, napr, nu, x0;
    x0 = canvWidth / 2;
    napr = (y - 2 * d2) / 3 / d2;
    kapr = (x - x0 + napr * d1) / 2 / d1;
    nu = Math.floor(napr);
    ku = Math.floor(kapr);
    if (testPoint(x, y, x0, nu, ku)) {
      return {
        n: nu,
        k: ku
      };
    } else if (testPoint(x, y, x0, nu + 1, ku)) {
      return {
        n: nu + 1,
        k: ku
      };
    } else if (testPoint(x, y, x0, nu + 1, ku + 1)) {
      return {
        n: nu + 1,
        k: ku + 1
      };
    } else if (testPoint(x, y, x0, nu, ku + 1)) {
      return {
        n: nu,
        k: ku + 1
      };
    } else {
      return {
        n: 'bad',
        k: 'bad'
      };
    }
  };

  testPoint = function(x, y, x0, n, k) {
    var c1, c2, c3, e1, e2, e3;
    e1 = x0 + (2 * k - n) * d1;
    e2 = (x - x0) * (d2 / d1) + 4 * n * d2 - 2 * k * d2;
    e3 = (x0 - x) * (d2 / d1) + 2 * n * d2 + 2 * k * d2;
    c1 = x >= e1 - d1 && x <= e1 + d1;
    c2 = y >= e2 && y <= e2 + 4 * d2;
    c3 = y >= e3 && y <= e3 + 4 * d2;
    return c1 && c2 && c3;
  };

  getValue = function(mousePos) {
    var k, n, _ref;
    _ref = getNK(mousePos.x, mousePos.y), n = _ref.n, k = _ref.k;
    return "Entry: " + (n >= k && k >= 0 && n <= rowCount ? n + "C" + k + " = " + Math.round(nCk(n, k)) + "<br/>" + tri[n][k] + " (mod " + modBase + ")" : "n/a");
  };

  makeRow = function(prev) {
    var a2, n;
    a2 = (function() {
      var _i, _ref, _results;
      _results = [];
      for (n = _i = 0, _ref = prev.length - 2; 0 <= _ref ? _i <= _ref : _i >= _ref; n = 0 <= _ref ? ++_i : --_i) {
        _results.push((prev[n] + prev[n + 1]) % modBase);
      }
      return _results;
    })();
    a2.push(1);
    a2.unshift(1);
    return a2;
  };

  buildTriangle = function(max) {
    var current, n, results;
    results = [[1]];
    current = [1, 1];
    results.push(current);
    n = 1;
    while (n < max) {
      current = makeRow(current);
      results.push(current);
      n += 1;
    }
    return results;
  };

  calcAreas = function() {
    var flattened, num, r, _i, _len, _results;
    flattened = tri.reduce(function(a, b) {
      return a.concat(b);
    });
    modAreas = (function() {
      var _i, _results;
      _results = [];
      for (num = _i = 0; 0 <= modBase ? _i < modBase : _i > modBase; num = 0 <= modBase ? ++_i : --_i) {
        _results.push(0);
      }
      return _results;
    })();
    _results = [];
    for (_i = 0, _len = flattened.length; _i < _len; _i++) {
      r = flattened[_i];
      _results.push(modAreas[r] += 1);
    }
    return _results;
  };

  draw_hexagons = function(triangle) {
    var i, startX, startY, _i, _ref, _results;
    startX = canvWidth / 2;
    startY = 0;
    _results = [];
    for (i = _i = 0, _ref = triangle.length; 0 <= _ref ? _i < _ref : _i > _ref; i = 0 <= _ref ? ++_i : --_i) {
      _results.push(draw_row(startX - i * d1, startY + i * (3 * d2), triangle[i]));
    }
    return _results;
  };

  draw_row = function(startX, startY, row) {
    var i, _i, _ref, _results;
    _results = [];
    for (i = _i = 0, _ref = row.length; 0 <= _ref ? _i < _ref : _i > _ref; i = 0 <= _ref ? ++_i : --_i) {
      _results.push(draw_hexagon(startX + 2 * d1 * i, startY, modColors[row[i]]));
    }
    return _results;
  };

  draw_hexagon = function(x, y, fillColor) {
    ctx.fillStyle = fillColor;
    ctx.strokeStyle = '#999';
    ctx.beginPath();
    ctx.moveTo(x, y);
    ctx.lineTo(x + d1, y + d2);
    ctx.lineTo(x + d1, y + 3 * d2);
    ctx.lineTo(x, y + 4 * d2);
    ctx.lineTo(x - d1, y + 3 * d2);
    ctx.lineTo(x - d1, y + d2);
    ctx.closePath();
    ctx.fill();
    ctx.lineWidth = 1;
    return ctx.stroke();
  };

  displayAreas = function() {
    var area, i, totArea, _i, _len, _results;
    $("#areas").remove();
    $("#histogram").append('<ul id="areas"></ul>');
    i = 0;
    totArea = modAreas.reduce(function(a, b) {
      return a + b;
    });
    _results = [];
    for (_i = 0, _len = modAreas.length; _i < _len; _i++) {
      area = modAreas[_i];
      $("#areas").append('<li>' + i + ": " + area + ' = ' + Math.round(area * 100 / totArea) + '%</li>');
      _results.push(i += 1);
    }
    return _results;
  };

  add_swatches = function() {
    var color, i, _i, _len, _results;
    i = 0;
    _results = [];
    for (_i = 0, _len = modColors.length; _i < _len; _i++) {
      color = modColors[_i];
      $("#swatches").append('<div class="swatch"' + ' style="background-color: ' + color + '">' + i + '</div>');
      _results.push(i += 1);
    }
    return _results;
  };

  $("#rows").change(function() {
    rowCount = parseInt($(this).val());
    $("#lrows").html(rowCount);
    refresh();
    return true;
  });

  $("#modBase").change(function() {
    modBase = parseInt($(this).val());
    $("#lmodBase").html(modBase);
    refresh();
    return true;
  });

  $("#canvWidth").change(function() {
    canvWidth = parseInt($(this).val());
    $("#lcanvWidth").html(canvWidth);
    refresh();
    return true;
  });

  refresh = function() {
    setLayout();
    clear();
    tri = buildTriangle(rowCount);
    draw_hexagons(tri);
    calcAreas();
    return displayAreas();
  };

  window.onload = function() {
    add_swatches();
    rowCount = parseInt($("#rows").val());
    modBase = parseInt($("#modBase").val());
    canvWidth = parseInt($("#canvWidth").val());
    return refresh();
  };

}).call(this);
