let buildArgsList;

// `modulePromise` is a promise to the `WebAssembly.module` object to be
//   instantiated.
// `importObjectPromise` is a promise to an object that contains any additional
//   imports needed by the module that aren't provided by the standard runtime.
//   The fields on this object will be merged into the importObject with which
//   the module will be instantiated.
// This function returns a promise to the instantiated module.
export const instantiate = async (modulePromise, importObjectPromise) => {
    let dartInstance;

    function stringFromDartString(string) {
        const totalLength = dartInstance.exports.$stringLength(string);
        let result = '';
        let index = 0;
        while (index < totalLength) {
          let chunkLength = Math.min(totalLength - index, 0xFFFF);
          const array = new Array(chunkLength);
          for (let i = 0; i < chunkLength; i++) {
              array[i] = dartInstance.exports.$stringRead(string, index++);
          }
          result += String.fromCharCode(...array);
        }
        return result;
    }

    function stringToDartString(string) {
        const length = string.length;
        let range = 0;
        for (let i = 0; i < length; i++) {
            range |= string.codePointAt(i);
        }
        if (range < 256) {
            const dartString = dartInstance.exports.$stringAllocate1(length);
            for (let i = 0; i < length; i++) {
                dartInstance.exports.$stringWrite1(dartString, i, string.codePointAt(i));
            }
            return dartString;
        } else {
            const dartString = dartInstance.exports.$stringAllocate2(length);
            for (let i = 0; i < length; i++) {
                dartInstance.exports.$stringWrite2(dartString, i, string.charCodeAt(i));
            }
            return dartString;
        }
    }

    // Prints to the console
    function printToConsole(value) {
      if (typeof dartPrint == "function") {
        dartPrint(value);
        return;
      }
      if (typeof console == "object" && typeof console.log != "undefined") {
        console.log(value);
        return;
      }
      if (typeof print == "function") {
        print(value);
        return;
      }

      throw "Unable to print message: " + js;
    }

    // Converts a Dart List to a JS array. Any Dart objects will be converted, but
    // this will be cheap for JSValues.
    function arrayFromDartList(constructor, list) {
        const length = dartInstance.exports.$listLength(list);
        const array = new constructor(length);
        for (let i = 0; i < length; i++) {
            array[i] = dartInstance.exports.$listRead(list, i);
        }
        return array;
    }

    buildArgsList = function(list) {
        const dartList = dartInstance.exports.$makeStringList();
        for (let i = 0; i < list.length; i++) {
            dartInstance.exports.$listAdd(dartList, stringToDartString(list[i]));
        }
        return dartList;
    }

    // A special symbol attached to functions that wrap Dart functions.
    const jsWrappedDartFunctionSymbol = Symbol("JSWrappedDartFunction");

    function finalizeWrapper(dartFunction, wrapped) {
        wrapped.dartFunction = dartFunction;
        wrapped[jsWrappedDartFunctionSymbol] = true;
        return wrapped;
    }

    // Imports
    const dart2wasm = {

_1: (x0,x1,x2) => x0.set(x1,x2),
_2: (x0,x1,x2) => x0.set(x1,x2),
_6: f => finalizeWrapper(f,x0 => dartInstance.exports._6(f,x0)),
_7: x0 => new window.FinalizationRegistry(x0),
_8: (x0,x1,x2,x3) => x0.register(x1,x2,x3),
_9: (x0,x1) => x0.unregister(x1),
_10: (x0,x1,x2) => x0.slice(x1,x2),
_11: (x0,x1) => x0.decode(x1),
_12: (x0,x1) => x0.segment(x1),
_13: () => new TextDecoder(),
_14: x0 => x0.buffer,
_15: x0 => x0.wasmMemory,
_16: () => globalThis.window._flutter_skwasmInstance,
_17: x0 => x0.rasterStartMilliseconds,
_18: x0 => x0.rasterEndMilliseconds,
_19: x0 => x0.imageBitmaps,
_166: x0 => x0.focus(),
_167: x0 => x0.select(),
_168: (x0,x1) => x0.append(x1),
_169: x0 => x0.remove(),
_172: x0 => x0.unlock(),
_177: x0 => x0.getReader(),
_187: x0 => new MutationObserver(x0),
_206: (x0,x1,x2) => x0.addEventListener(x1,x2),
_207: (x0,x1,x2) => x0.removeEventListener(x1,x2),
_210: x0 => new ResizeObserver(x0),
_213: (x0,x1) => new Intl.Segmenter(x0,x1),
_214: x0 => x0.next(),
_215: (x0,x1) => new Intl.v8BreakIterator(x0,x1),
_300: f => finalizeWrapper(f,x0 => dartInstance.exports._300(f,x0)),
_301: f => finalizeWrapper(f,x0 => dartInstance.exports._301(f,x0)),
_302: (x0,x1) => ({addView: x0,removeView: x1}),
_303: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._303(f,arguments.length,x0) }),
_304: f => finalizeWrapper(f,() => dartInstance.exports._304(f)),
_305: (x0,x1) => ({initializeEngine: x0,autoStart: x1}),
_306: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._306(f,arguments.length,x0) }),
_307: x0 => ({runApp: x0}),
_308: x0 => new Uint8Array(x0),
_310: x0 => x0.preventDefault(),
_311: x0 => x0.stopPropagation(),
_312: (x0,x1) => x0.addListener(x1),
_313: (x0,x1) => x0.removeListener(x1),
_314: (x0,x1) => x0.prepend(x1),
_315: x0 => x0.remove(),
_316: x0 => x0.disconnect(),
_317: (x0,x1) => x0.addListener(x1),
_318: (x0,x1) => x0.removeListener(x1),
_321: (x0,x1) => x0.append(x1),
_322: x0 => x0.remove(),
_323: x0 => x0.stopPropagation(),
_327: x0 => x0.preventDefault(),
_328: (x0,x1) => x0.append(x1),
_329: x0 => x0.remove(),
_334: (x0,x1) => x0.appendChild(x1),
_335: (x0,x1,x2) => x0.insertBefore(x1,x2),
_336: (x0,x1) => x0.removeChild(x1),
_337: (x0,x1) => x0.appendChild(x1),
_338: (x0,x1) => x0.transferFromImageBitmap(x1),
_339: (x0,x1) => x0.append(x1),
_340: (x0,x1) => x0.append(x1),
_341: (x0,x1) => x0.append(x1),
_342: x0 => x0.remove(),
_343: x0 => x0.focus(),
_344: x0 => x0.focus(),
_345: x0 => x0.remove(),
_346: x0 => x0.focus(),
_347: x0 => x0.remove(),
_348: x0 => x0.focus(),
_349: (x0,x1) => x0.appendChild(x1),
_350: (x0,x1) => x0.appendChild(x1),
_351: x0 => x0.remove(),
_352: (x0,x1) => x0.append(x1),
_353: (x0,x1) => x0.append(x1),
_354: x0 => x0.remove(),
_355: (x0,x1) => x0.append(x1),
_356: (x0,x1) => x0.append(x1),
_357: (x0,x1,x2) => x0.insertBefore(x1,x2),
_358: (x0,x1) => x0.append(x1),
_359: (x0,x1,x2) => x0.insertBefore(x1,x2),
_360: x0 => x0.remove(),
_361: x0 => x0.remove(),
_362: (x0,x1) => x0.append(x1),
_363: x0 => x0.remove(),
_364: (x0,x1) => x0.append(x1),
_365: x0 => x0.remove(),
_366: x0 => x0.remove(),
_367: x0 => x0.getBoundingClientRect(),
_368: x0 => x0.remove(),
_369: x0 => x0.blur(),
_371: x0 => x0.focus(),
_372: x0 => x0.focus(),
_373: x0 => x0.remove(),
_374: x0 => x0.focus(),
_375: x0 => x0.focus(),
_376: x0 => x0.blur(),
_377: x0 => x0.remove(),
_390: (x0,x1) => x0.append(x1),
_391: x0 => x0.remove(),
_392: (x0,x1) => x0.append(x1),
_393: (x0,x1,x2) => x0.insertBefore(x1,x2),
_394: x0 => x0.focus(),
_395: x0 => x0.focus(),
_396: x0 => x0.focus(),
_397: x0 => x0.focus(),
_398: x0 => x0.focus(),
_399: x0 => x0.focus(),
_400: x0 => x0.blur(),
_401: x0 => x0.remove(),
_403: x0 => x0.preventDefault(),
_404: x0 => x0.focus(),
_405: x0 => x0.preventDefault(),
_406: x0 => x0.preventDefault(),
_407: x0 => x0.preventDefault(),
_408: x0 => x0.focus(),
_409: x0 => x0.focus(),
_410: x0 => x0.focus(),
_411: x0 => x0.focus(),
_412: x0 => x0.focus(),
_413: x0 => x0.focus(),
_414: (x0,x1) => x0.observe(x1),
_415: x0 => x0.disconnect(),
_416: (x0,x1) => x0.appendChild(x1),
_417: (x0,x1) => x0.appendChild(x1),
_418: (x0,x1) => x0.appendChild(x1),
_419: (x0,x1) => x0.append(x1),
_420: x0 => x0.remove(),
_421: (x0,x1) => x0.append(x1),
_423: (x0,x1) => x0.appendChild(x1),
_424: (x0,x1) => x0.append(x1),
_425: x0 => x0.remove(),
_426: (x0,x1) => x0.append(x1),
_430: (x0,x1) => x0.appendChild(x1),
_431: x0 => x0.remove(),
_993: () => globalThis.window.flutterConfiguration,
_994: x0 => x0.assetBase,
_999: x0 => x0.debugShowSemanticsNodes,
_1000: x0 => x0.hostElement,
_1001: x0 => x0.multiViewEnabled,
_1002: x0 => x0.nonce,
_1004: x0 => x0.fontFallbackBaseUrl,
_1005: x0 => x0.useColorEmoji,
_1009: x0 => x0.console,
_1010: x0 => x0.devicePixelRatio,
_1011: x0 => x0.document,
_1012: x0 => x0.history,
_1013: x0 => x0.innerHeight,
_1014: x0 => x0.innerWidth,
_1015: x0 => x0.location,
_1016: x0 => x0.navigator,
_1017: x0 => x0.visualViewport,
_1018: x0 => x0.performance,
_1019: (x0,x1) => x0.fetch(x1),
_1022: (x0,x1) => x0.dispatchEvent(x1),
_1023: (x0,x1) => x0.matchMedia(x1),
_1024: (x0,x1) => x0.getComputedStyle(x1),
_1026: x0 => x0.screen,
_1027: (x0,x1) => x0.requestAnimationFrame(x1),
_1028: f => finalizeWrapper(f,x0 => dartInstance.exports._1028(f,x0)),
_1032: (x0,x1) => x0.warn(x1),
_1036: () => globalThis.window,
_1037: () => globalThis.Intl,
_1038: () => globalThis.Symbol,
_1041: x0 => x0.clipboard,
_1042: x0 => x0.maxTouchPoints,
_1043: x0 => x0.vendor,
_1044: x0 => x0.language,
_1045: x0 => x0.platform,
_1046: x0 => x0.userAgent,
_1047: x0 => x0.languages,
_1048: x0 => x0.documentElement,
_1050: (x0,x1) => x0.querySelector(x1),
_1052: (x0,x1) => x0.createElement(x1),
_1055: (x0,x1) => x0.execCommand(x1),
_1058: (x0,x1) => x0.createTextNode(x1),
_1059: (x0,x1) => x0.createEvent(x1),
_1064: x0 => x0.head,
_1065: x0 => x0.body,
_1066: (x0,x1) => x0.title = x1,
_1070: x0 => x0.activeElement,
_1072: x0 => x0.visibilityState,
_1073: () => globalThis.document,
_1074: (x0,x1,x2) => x0.addEventListener(x1,x2),
_1075: (x0,x1,x2,x3) => x0.addEventListener(x1,x2,x3),
_1076: (x0,x1,x2,x3) => x0.addEventListener(x1,x2,x3),
_1077: (x0,x1,x2) => x0.removeEventListener(x1,x2),
_1080: f => finalizeWrapper(f,x0 => dartInstance.exports._1080(f,x0)),
_1081: x0 => x0.target,
_1083: x0 => x0.timeStamp,
_1084: x0 => x0.type,
_1085: x0 => x0.preventDefault(),
_1090: (x0,x1,x2,x3) => x0.initEvent(x1,x2,x3),
_1095: x0 => x0.firstChild,
_1100: x0 => x0.parentElement,
_1102: x0 => x0.parentNode,
_1105: (x0,x1) => x0.removeChild(x1),
_1106: (x0,x1) => x0.removeChild(x1),
_1107: x0 => x0.isConnected,
_1108: (x0,x1) => x0.textContent = x1,
_1110: (x0,x1) => x0.contains(x1),
_1115: x0 => x0.firstElementChild,
_1117: x0 => x0.nextElementSibling,
_1118: x0 => x0.clientHeight,
_1119: x0 => x0.clientWidth,
_1120: x0 => x0.offsetHeight,
_1121: x0 => x0.offsetWidth,
_1122: x0 => x0.id,
_1123: (x0,x1) => x0.id = x1,
_1126: (x0,x1) => x0.spellcheck = x1,
_1127: x0 => x0.tagName,
_1128: x0 => x0.style,
_1129: (x0,x1) => x0.append(x1),
_1130: (x0,x1) => x0.getAttribute(x1),
_1131: x0 => x0.getBoundingClientRect(),
_1134: (x0,x1) => x0.closest(x1),
_1136: (x0,x1) => x0.querySelectorAll(x1),
_1137: x0 => x0.remove(),
_1139: (x0,x1,x2) => x0.setAttribute(x1,x2),
_1141: (x0,x1) => x0.removeAttribute(x1),
_1142: (x0,x1) => x0.tabIndex = x1,
_1146: x0 => x0.scrollTop,
_1147: (x0,x1) => x0.scrollTop = x1,
_1148: x0 => x0.scrollLeft,
_1149: (x0,x1) => x0.scrollLeft = x1,
_1150: x0 => x0.classList,
_1151: (x0,x1) => x0.className = x1,
_1155: (x0,x1) => x0.getElementsByClassName(x1),
_1156: x0 => x0.click(),
_1158: (x0,x1) => x0.hasAttribute(x1),
_1161: (x0,x1) => x0.attachShadow(x1),
_1164: (x0,x1) => x0.getPropertyValue(x1),
_1166: (x0,x1,x2,x3) => x0.setProperty(x1,x2,x3),
_1168: (x0,x1) => x0.removeProperty(x1),
_1170: x0 => x0.offsetLeft,
_1171: x0 => x0.offsetTop,
_1172: x0 => x0.offsetParent,
_1174: (x0,x1) => x0.name = x1,
_1175: x0 => x0.content,
_1176: (x0,x1) => x0.content = x1,
_1189: (x0,x1) => x0.nonce = x1,
_1194: x0 => x0.now(),
_1196: (x0,x1) => x0.width = x1,
_1198: (x0,x1) => x0.height = x1,
_1202: (x0,x1) => x0.getContext(x1),
_1278: x0 => x0.status,
_1280: x0 => x0.body,
_1282: x0 => x0.arrayBuffer(),
_1287: x0 => x0.read(),
_1288: x0 => x0.value,
_1289: x0 => x0.done,
_1292: x0 => x0.x,
_1293: x0 => x0.y,
_1296: x0 => x0.top,
_1297: x0 => x0.right,
_1298: x0 => x0.bottom,
_1299: x0 => x0.left,
_1308: x0 => x0.height,
_1309: x0 => x0.width,
_1310: (x0,x1) => x0.value = x1,
_1312: (x0,x1) => x0.placeholder = x1,
_1313: (x0,x1) => x0.name = x1,
_1314: x0 => x0.selectionDirection,
_1315: x0 => x0.selectionStart,
_1316: x0 => x0.selectionEnd,
_1319: x0 => x0.value,
_1321: (x0,x1,x2) => x0.setSelectionRange(x1,x2),
_1326: x0 => x0.readText(),
_1327: (x0,x1) => x0.writeText(x1),
_1328: x0 => x0.altKey,
_1329: x0 => x0.code,
_1330: x0 => x0.ctrlKey,
_1331: x0 => x0.key,
_1332: x0 => x0.keyCode,
_1333: x0 => x0.location,
_1334: x0 => x0.metaKey,
_1335: x0 => x0.repeat,
_1336: x0 => x0.shiftKey,
_1337: x0 => x0.isComposing,
_1338: (x0,x1) => x0.getModifierState(x1),
_1339: x0 => x0.state,
_1343: (x0,x1) => x0.go(x1),
_1344: (x0,x1,x2,x3) => x0.pushState(x1,x2,x3),
_1345: (x0,x1,x2,x3) => x0.replaceState(x1,x2,x3),
_1346: x0 => x0.pathname,
_1347: x0 => x0.search,
_1348: x0 => x0.hash,
_1351: x0 => x0.state,
_1356: f => finalizeWrapper(f,(x0,x1) => dartInstance.exports._1356(f,x0,x1)),
_1358: (x0,x1,x2) => x0.observe(x1,x2),
_1361: x0 => x0.attributeName,
_1362: x0 => x0.type,
_1363: x0 => x0.matches,
_1366: x0 => x0.matches,
_1367: x0 => x0.relatedTarget,
_1368: x0 => x0.clientX,
_1369: x0 => x0.clientY,
_1370: x0 => x0.offsetX,
_1371: x0 => x0.offsetY,
_1374: x0 => x0.button,
_1375: x0 => x0.buttons,
_1376: x0 => x0.ctrlKey,
_1377: (x0,x1) => x0.getModifierState(x1),
_1378: x0 => x0.pointerId,
_1379: x0 => x0.pointerType,
_1380: x0 => x0.pressure,
_1381: x0 => x0.tiltX,
_1382: x0 => x0.tiltY,
_1383: x0 => x0.getCoalescedEvents(),
_1384: x0 => x0.deltaX,
_1385: x0 => x0.deltaY,
_1386: x0 => x0.wheelDeltaX,
_1387: x0 => x0.wheelDeltaY,
_1388: x0 => x0.deltaMode,
_1393: x0 => x0.changedTouches,
_1395: x0 => x0.clientX,
_1396: x0 => x0.clientY,
_1397: x0 => x0.data,
_1398: (x0,x1) => x0.type = x1,
_1399: (x0,x1) => x0.max = x1,
_1400: (x0,x1) => x0.min = x1,
_1401: (x0,x1) => x0.value = x1,
_1402: x0 => x0.value,
_1403: x0 => x0.disabled,
_1404: (x0,x1) => x0.disabled = x1,
_1405: (x0,x1) => x0.placeholder = x1,
_1406: (x0,x1) => x0.name = x1,
_1407: (x0,x1) => x0.autocomplete = x1,
_1408: x0 => x0.selectionDirection,
_1409: x0 => x0.selectionStart,
_1410: x0 => x0.selectionEnd,
_1413: (x0,x1,x2) => x0.setSelectionRange(x1,x2),
_1419: (x0,x1) => x0.add(x1),
_1423: (x0,x1) => x0.noValidate = x1,
_1424: (x0,x1) => x0.method = x1,
_1425: (x0,x1) => x0.action = x1,
_1452: x0 => x0.orientation,
_1453: x0 => x0.width,
_1454: x0 => x0.height,
_1455: (x0,x1) => x0.lock(x1),
_1472: f => finalizeWrapper(f,(x0,x1) => dartInstance.exports._1472(f,x0,x1)),
_1482: x0 => x0.length,
_1484: (x0,x1) => x0.item(x1),
_1485: x0 => x0.length,
_1486: (x0,x1) => x0.item(x1),
_1487: x0 => x0.iterator,
_1488: x0 => x0.Segmenter,
_1489: x0 => x0.v8BreakIterator,
_1492: x0 => x0.done,
_1493: x0 => x0.value,
_1494: x0 => x0.index,
_1498: (x0,x1) => x0.adoptText(x1),
_1499: x0 => x0.first(),
_1501: x0 => x0.next(),
_1502: x0 => x0.current(),
_1514: x0 => x0.hostElement,
_1515: x0 => x0.viewConstraints,
_1517: x0 => x0.maxHeight,
_1518: x0 => x0.maxWidth,
_1519: x0 => x0.minHeight,
_1520: x0 => x0.minWidth,
_1521: x0 => x0.loader,
_1522: () => globalThis._flutter,
_1523: (x0,x1) => x0.didCreateEngineInitializer(x1),
_1524: (x0,x1,x2) => x0.call(x1,x2),
_1525: () => globalThis.Promise,
_1526: f => finalizeWrapper(f,(x0,x1) => dartInstance.exports._1526(f,x0,x1)),
_1531: x0 => x0.length,
_1627: (x0,x1,x2,x3) => x0.open(x1,x2,x3),
_1638: x0 => new Array(x0),
_1672: (decoder, codeUnits) => decoder.decode(codeUnits),
_1673: () => new TextDecoder("utf-8", {fatal: true}),
_1674: () => new TextDecoder("utf-8", {fatal: false}),
_1675: v => stringToDartString(v.toString()),
_1676: (d, digits) => stringToDartString(d.toFixed(digits)),
_1680: x0 => new WeakRef(x0),
_1681: x0 => x0.deref(),
_1687: Date.now,
_1689: s => new Date(s * 1000).getTimezoneOffset() * 60 ,
_1690: s => {
      const jsSource = stringFromDartString(s);
      if (!/^\s*[+-]?(?:Infinity|NaN|(?:\.\d+|\d+(?:\.\d*)?)(?:[eE][+-]?\d+)?)\s*$/.test(jsSource)) {
        return NaN;
      }
      return parseFloat(jsSource);
    },
_1691: () => {
          let stackString = new Error().stack.toString();
          let frames = stackString.split('\n');
          let drop = 2;
          if (frames[0] === 'Error') {
              drop += 1;
          }
          return frames.slice(drop).join('\n');
        },
_1692: () => typeof dartUseDateNowForTicks !== "undefined",
_1693: () => 1000 * performance.now(),
_1694: () => Date.now(),
_1697: () => new WeakMap(),
_1698: (map, o) => map.get(o),
_1699: (map, o, v) => map.set(o, v),
_1700: () => globalThis.WeakRef,
_1711: s => stringToDartString(JSON.stringify(stringFromDartString(s))),
_1712: s => printToConsole(stringFromDartString(s)),
_1713: s => stringToDartString(stringFromDartString(s).toUpperCase()),
_1714: s => stringToDartString(stringFromDartString(s).toLowerCase()),
_1715: (a, i) => a.push(i),
_1719: a => a.pop(),
_1720: (a, i) => a.splice(i, 1),
_1722: (a, s) => a.join(s),
_1723: (a, s, e) => a.slice(s, e),
_1726: a => a.length,
_1728: (a, i) => a[i],
_1729: (a, i, v) => a[i] = v,
_1731: a => a.join(''),
_1734: (s, t) => s.split(t),
_1735: s => s.toLowerCase(),
_1736: s => s.toUpperCase(),
_1737: s => s.trim(),
_1738: s => s.trimLeft(),
_1739: s => s.trimRight(),
_1741: (s, p, i) => s.indexOf(p, i),
_1742: (s, p, i) => s.lastIndexOf(p, i),
_1743: (o, offsetInBytes, lengthInBytes) => {
      var dst = new ArrayBuffer(lengthInBytes);
      new Uint8Array(dst).set(new Uint8Array(o, offsetInBytes, lengthInBytes));
      return new DataView(dst);
    },
_1744: (o, start, length) => new Uint8Array(o.buffer, o.byteOffset + start, length),
_1745: (o, start, length) => new Int8Array(o.buffer, o.byteOffset + start, length),
_1746: (o, start, length) => new Uint8ClampedArray(o.buffer, o.byteOffset + start, length),
_1747: (o, start, length) => new Uint16Array(o.buffer, o.byteOffset + start, length),
_1748: (o, start, length) => new Int16Array(o.buffer, o.byteOffset + start, length),
_1749: (o, start, length) => new Uint32Array(o.buffer, o.byteOffset + start, length),
_1750: (o, start, length) => new Int32Array(o.buffer, o.byteOffset + start, length),
_1752: (o, start, length) => new BigInt64Array(o.buffer, o.byteOffset + start, length),
_1753: (o, start, length) => new Float32Array(o.buffer, o.byteOffset + start, length),
_1754: (o, start, length) => new Float64Array(o.buffer, o.byteOffset + start, length),
_1756: Object.is,
_1757: (t, s) => t.set(s),
_1759: (o) => new DataView(o.buffer, o.byteOffset, o.byteLength),
_1761: o => o.buffer,
_1762: o => o.byteOffset,
_1763: Function.prototype.call.bind(Object.getOwnPropertyDescriptor(DataView.prototype, 'byteLength').get),
_1764: (b, o) => new DataView(b, o),
_1765: (b, o, l) => new DataView(b, o, l),
_1766: Function.prototype.call.bind(DataView.prototype.getUint8),
_1767: Function.prototype.call.bind(DataView.prototype.setUint8),
_1768: Function.prototype.call.bind(DataView.prototype.getInt8),
_1769: Function.prototype.call.bind(DataView.prototype.setInt8),
_1770: Function.prototype.call.bind(DataView.prototype.getUint16),
_1771: Function.prototype.call.bind(DataView.prototype.setUint16),
_1772: Function.prototype.call.bind(DataView.prototype.getInt16),
_1773: Function.prototype.call.bind(DataView.prototype.setInt16),
_1774: Function.prototype.call.bind(DataView.prototype.getUint32),
_1775: Function.prototype.call.bind(DataView.prototype.setUint32),
_1776: Function.prototype.call.bind(DataView.prototype.getInt32),
_1777: Function.prototype.call.bind(DataView.prototype.setInt32),
_1780: Function.prototype.call.bind(DataView.prototype.getBigInt64),
_1781: Function.prototype.call.bind(DataView.prototype.setBigInt64),
_1782: Function.prototype.call.bind(DataView.prototype.getFloat32),
_1783: Function.prototype.call.bind(DataView.prototype.setFloat32),
_1784: Function.prototype.call.bind(DataView.prototype.getFloat64),
_1785: Function.prototype.call.bind(DataView.prototype.setFloat64),
_1791: (o, t) => o instanceof t,
_1793: f => finalizeWrapper(f,x0 => dartInstance.exports._1793(f,x0)),
_1794: f => finalizeWrapper(f,x0 => dartInstance.exports._1794(f,x0)),
_1795: o => Object.keys(o),
_1804: (ms, c) =>
              setTimeout(() => dartInstance.exports.$invokeCallback(c),ms),
_1805: (handle) => clearTimeout(handle),
_1806: (ms, c) =>
          setInterval(() => dartInstance.exports.$invokeCallback(c), ms),
_1807: (handle) => clearInterval(handle),
_1808: (c) =>
              queueMicrotask(() => dartInstance.exports.$invokeCallback(c)),
_1809: () => Date.now(),
_1838: (s, m) => {
          try {
            return new RegExp(s, m);
          } catch (e) {
            return String(e);
          }
        },
_1839: (x0,x1) => x0.exec(x1),
_1840: (x0,x1) => x0.test(x1),
_1841: (x0,x1) => x0.exec(x1),
_1842: (x0,x1) => x0.exec(x1),
_1843: x0 => x0.pop(),
_1847: (x0,x1,x2) => x0[x1] = x2,
_1849: o => o === undefined,
_1850: o => typeof o === 'boolean',
_1851: o => typeof o === 'number',
_1853: o => typeof o === 'string',
_1856: o => o instanceof Int8Array,
_1857: o => o instanceof Uint8Array,
_1858: o => o instanceof Uint8ClampedArray,
_1859: o => o instanceof Int16Array,
_1860: o => o instanceof Uint16Array,
_1861: o => o instanceof Int32Array,
_1862: o => o instanceof Uint32Array,
_1863: o => o instanceof Float32Array,
_1864: o => o instanceof Float64Array,
_1865: o => o instanceof ArrayBuffer,
_1866: o => o instanceof DataView,
_1867: o => o instanceof Array,
_1868: o => typeof o === 'function' && o[jsWrappedDartFunctionSymbol] === true,
_1870: o => {
            const proto = Object.getPrototypeOf(o);
            return proto === Object.prototype || proto === null;
          },
_1871: o => o instanceof RegExp,
_1872: (l, r) => l === r,
_1873: o => o,
_1874: o => o,
_1875: o => o,
_1876: b => !!b,
_1877: o => o.length,
_1880: (o, i) => o[i],
_1881: f => f.dartFunction,
_1882: l => arrayFromDartList(Int8Array, l),
_1883: l => arrayFromDartList(Uint8Array, l),
_1884: l => arrayFromDartList(Uint8ClampedArray, l),
_1885: l => arrayFromDartList(Int16Array, l),
_1886: l => arrayFromDartList(Uint16Array, l),
_1887: l => arrayFromDartList(Int32Array, l),
_1888: l => arrayFromDartList(Uint32Array, l),
_1889: l => arrayFromDartList(Float32Array, l),
_1890: l => arrayFromDartList(Float64Array, l),
_1891: (data, length) => {
          const view = new DataView(new ArrayBuffer(length));
          for (let i = 0; i < length; i++) {
              view.setUint8(i, dartInstance.exports.$byteDataGetUint8(data, i));
          }
          return view;
        },
_1892: l => arrayFromDartList(Array, l),
_1893: stringFromDartString,
_1894: stringToDartString,
_1895: () => ({}),
_1896: () => [],
_1897: l => new Array(l),
_1898: () => globalThis,
_1899: (constructor, args) => {
      const factoryFunction = constructor.bind.apply(
          constructor, [null, ...args]);
      return new factoryFunction();
    },
_1900: (o, p) => p in o,
_1901: (o, p) => o[p],
_1902: (o, p, v) => o[p] = v,
_1903: (o, m, a) => o[m].apply(o, a),
_1905: o => String(o),
_1906: (p, s, f) => p.then(s, f),
_1907: s => {
      let jsString = stringFromDartString(s);
      if (/[[\]{}()*+?.\\^$|]/.test(jsString)) {
          jsString = jsString.replace(/[[\]{}()*+?.\\^$|]/g, '\\$&');
      }
      return stringToDartString(jsString);
    },
_1910: x0 => x0.index,
_1912: x0 => x0.length,
_1914: (x0,x1) => x0[x1],
_1918: x0 => x0.flags,
_1919: x0 => x0.multiline,
_1920: x0 => x0.ignoreCase,
_1921: x0 => x0.unicode,
_1922: x0 => x0.dotAll,
_1923: (x0,x1) => x0.lastIndex = x1,
_3770: () => globalThis.window,
_3850: x0 => x0.navigator,
_4331: x0 => x0.userAgent
    };

    const baseImports = {
        dart2wasm: dart2wasm,


        Math: Math,
        Date: Date,
        Object: Object,
        Array: Array,
        Reflect: Reflect,
    };

    const jsStringPolyfill = {
        "charCodeAt": (s, i) => s.charCodeAt(i),
        "compare": (s1, s2) => {
            if (s1 < s2) return -1;
            if (s1 > s2) return 1;
            return 0;
        },
        "concat": (s1, s2) => s1 + s2,
        "equals": (s1, s2) => s1 === s2,
        "fromCharCode": (i) => String.fromCharCode(i),
        "length": (s) => s.length,
        "substring": (s, a, b) => s.substring(a, b),
    };

    dartInstance = await WebAssembly.instantiate(await modulePromise, {
        ...baseImports,
        ...(await importObjectPromise),
        "wasm:js-string": jsStringPolyfill,
    });

    return dartInstance;
}

// Call the main function for the instantiated module
// `moduleInstance` is the instantiated dart2wasm module
// `args` are any arguments that should be passed into the main function.
export const invoke = (moduleInstance, ...args) => {
    const dartMain = moduleInstance.exports.$getMain();
    const dartArgs = buildArgsList(args);
    moduleInstance.exports.$invokeMain(dartMain, dartArgs);
}

