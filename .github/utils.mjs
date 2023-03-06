export function safeJsonParse(str, desc = "") {
  try {
    // todo: require('json5').parse(str);
    str = str
      .replace(/^ *\/\/.+/gm, "")
      .replace(/ \/\/[^"]+\n/gm, "")
      .trim();
    return JSON.parse(str);
  } catch (error) {
    if (desc) console.error("[JSON.parse][error]", desc, error.message);
    return {};
  }
}

export function getRBVersion(content) {
    return /^ +version "(.+)"/m.exec(content)?.[1] || '';
}
