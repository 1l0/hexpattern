// js snippet

function key2hsl(hexKey) {
  if (hexKey.length !== 64) {
    throw new Error("key length must be 64");
  }
  const h1 = BigInt('0x' + hexKey.substring(0, 8));
  const s1 = BigInt('0x' + hexKey.substring(8, 16));
  const h2 = BigInt('0x' + hexKey.substring(16, 24));
  const s2 = BigInt('0x' + hexKey.substring(24, 32));
  const h3 = BigInt('0x' + hexKey.substring(32, 40));
  const s3 = BigInt('0x' + hexKey.substring(40, 48));
  const h4 = BigInt('0x' + hexKey.substring(48, 56));
  const s4 = BigInt('0x' + hexKey.substring(56, 64));
  const h = h1 ^ h2 ^ h3 ^ h4;
  const s = s1 ^ s2 ^ s3 ^ s4;
  const hue = Number(h % BigInt(360));
  const rawSat = Number(s % BigInt(100));
  const sat = Math.sin(Math.PI * (rawSat * 0.005)) * 100;
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
