// js snippet

function key2hsl(hexKey) {
  if (hexKey.length !== 64) {
    throw new Error("key length must be 64");
  }
  const hue = Number((BigInt('0x' + hexKey.substring(0, 8)) ^ BigInt('0x' + hexKey.substring(16, 24)) ^ BigInt('0x' + hexKey.substring(32, 40)) ^ BigInt('0x' + hexKey.substring(48, 56))) % BigInt(360));
  const sat = Math.sin(Math.PI * (Number((BigInt('0x' + hexKey.substring(8, 16)) ^ BigInt('0x' + hexKey.substring(24, 32)) ^ BigInt('0x' + hexKey.substring(40, 48)) ^ BigInt('0x' + hexKey.substring(56, 64))) % BigInt(100)) * 0.005)) * 100;
  return {
    hue: hue,
    sat: sat,
    lit: 50,
  };
}

const hsl = key2hsl("3c7d12a6c2f71fe9ca2527216f529a137bb0f2eb018b18f30003933b9532013e");
const col = "hsl(" + hsl.hue + ", " + hsl.sat + "%, " + hsl.lit + "%)";
document.body.textContent = col;
document.body.style.backgroundColor = col;


function key2hsl_not_optimized(hexKey) {
  if (hexKey.length !== 64) {
    throw new Error("key length must be 64");
  }
  const hcap = BigInt(360);
  const scap = BigInt(100);
  var h = BigInt(0);
  var s = BigInt(0);
  for (let i = 0; i < 8; i++) {
    let v = BigInt('0x' + hexKey.substring(i * 8, i * 8 + 8));
    if (i % 2 == 0) {
      h ^= v;
    } else {
      s ^= v;
    }
  }
  let hue = Number(h % hcap);
  let rawSat = Number(s % scap);
  let sat = Math.sin(Math.PI * (rawSat * 0.005)) * 100;
  return {
    hue: hue,
    sat: sat,
    lit: 50,
  };
}