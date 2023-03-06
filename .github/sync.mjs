import fs from "node:fs";
import path from "node:path";
import { fileURLToPath } from 'node:url';
import { color, semverCompare, execSync, getLogger, mkdirp, rmrf } from "@lzwme/fe-utils";
import { getRBVersion } from "./utils.mjs";

const isDebug = process.argv.slice(2).includes("--debug");
const isCI = process.env.SYNC != null;
const logger = getLogger("SYNC", isDebug ? "debug" : "log");
const rootDir = path.resolve(fileURLToPath(import.meta.url), "../..");
const CONFIG = {
  tmpDir: path.resolve("tmp"),
  repo: [
    `Homebrew/homebrew-core`,
    `Homebrew/homebrew-cask`,
    `Homebrew/homebrew-cask-fonts`,
    `Homebrew/homebrew-cask-versions`,
    `Homebrew/homebrew-cask-drivers`,
    `nicerloop/homebrew-nicerloop`,
    `codello/homebrew-brewery`,
    `shivammathur/homebrew-php`,
    `https://raw.githubusercontent.com/lencx/ChatGPT/main/casks/chatgpt.rb`,
  ],
  filter: /\.gitkeep|__/,
  syncExt: new Set([".rb", ".sh"]), // 允许同步的文件类型
  onlySyncFixed: false, // 是否仅同步内容被修正过的文件
  sourcesStatFile: path.resolve(rootDir, `sync-sources.csv`),
  lowPriorityFile: path.resolve(rootDir, "low-priority.txt"),
  ignoredFile: path.resolve(rootDir, "rb-ignored.txt"),
};
const destFilesCache = new Map();
const lowPrioritySet = parseTxtFile(CONFIG.lowPriorityFile);
const ignoredSet = parseTxtFile(CONFIG.ignoredFile);

function parseTxtFile(filename) {
  filename = path.resolve(CONFIG.rootDir, filename);
  const str =  fs.existsSync(filename) ? fs.readFileSync(filename, "utf8").trim() : '';
  const list = str
    .split("\n")
    .filter((d) => d && !d.startsWith("#"))
    .map((d) => {
      if (d.includes(", ")) return path.resolve(CONFIG.tmpDir, d.replace("/", "-").replace(", ", "/"));
      return d;
    });

  return new Set(list);
}

async function checkout(repo, dirName) {
  if (!fs.existsSync(CONFIG.tmpDir)) fs.mkdirSync(CONFIG.tmpDir);

  try {
    const dirpath = path.resolve(CONFIG.tmpDir, dirName);
    if (fs.existsSync(dirpath)) {
      execSync(`cd "${dirpath}" && git pull`, 'pipe', CONFIG.tmpDir);
    } else {
      repo = isDebug ? `https://ghproxy.com//github.com/${repo}` : `https://github.com/${repo}.git`;
      execSync(`git clone --depth 1 ${repo} ${dirName}`, 'pipe', CONFIG.tmpDir)
    }
  } catch (error) {
    logger.error(`checkout ${repo} failed!`, error.message);
  }
}

async function syncDir(src, dest, repo = "") {
  let total = 0;
  const basename = path.basename(src);

  src = path.resolve(rootDir, src);
  dest = path.resolve(rootDir, dest);

  if (!fs.existsSync(src) || CONFIG.filter.test(basename)) return total;
  if (ignoredSet.has(basename) || ignoredSet.has(src)) return;

  const stats = fs.statSync(src);
  const ext = path.extname(src).toLowerCase();

  if (stats.isFile()) {
    if (!CONFIG.syncExt.has(ext)) return total;

    const srcRelative = src.slice(CONFIG.tmpDir.length + 1);
    const destLowerCase = String(dest).toLowerCase();
    let content = "";

    if (destFilesCache.has(destLowerCase)) {
      if (".rb" !== ext || lowPrioritySet.has(src) || lowPrioritySet.has(basename)) return total;

      dest = destFilesCache.get(destLowerCase).dest; // 使用旧路径
      try {
        content = fs.readFileSync(src, "utf8").trim();
        const destVersion = getRBVersion(fs.readFileSync(dest, "utf8"));
        if (semverCompare(getRBVersion(content), destVersion, false) < 1) return total;
      } catch (e) {
        logger.error("[error]try compare version failed!", src, dest, e.message);
        return total;
      }
    }

    const cacheItem = { dest, src: srcRelative, repo, fixed: false };

    if ([".rb", ".sh"].includes(ext)) {
      if (!content) content = fs.readFileSync(src, "utf8").trim();
      const rawContent = content;

      if (basename.startsWith("node")) {
        content = content.replace(/(https:\/\/nodejs\.org\/dist\/)/gim, "https://registry.npmmirror.com/-/binary/node/");
      } else if (content.includes("github.com") || content.includes("githubusercontent.com")) {
        content = content
          .replace(/(https:\/\/github\.com.+\/releases\/download\/)/gim, "https://ghproxy.com/$1")
          .replace(/(https:\/\/github\.com.+\/archive\/)/gim, "https://ghproxy.com/$1")
          .replace(/(https\:\/\/(raw|gist)\.githubusercontent\.com)/gim, "https://ghproxy.com/$1")
          .replaceAll("https://ghproxy.com/https://ghproxy.com", "https://ghproxy.com");
      }

      cacheItem.fixed = content !== rawContent;
      if (CONFIG.onlySyncFixed && !cacheItem.fixed) return total;

      fs.writeFileSync(dest, content, "utf8");
    } else {
      fs.writeFileSync(dest, fs.readFileSync(src));
    }

    destFilesCache.set(destLowerCase, cacheItem);
    return ++total;
  }

  if (stats.isDirectory()) {
    if (!fs.existsSync(dest)) fs.mkdirSync(dest, { recursive: true });

    const list = fs.readdirSync(src);
    for (let filename of list) {
      total += await syncDir(path.resolve(src, filename), path.resolve(dest, filename), repo);
    }
  }

  return total;
}

async function gitCommit() {
  const changes = execSync("git status --short", 'inherit', rootDir).trim(); // --untracked-files=no
  if (changes.length > 5) {
    logger.info("Changes:\n", changes);
    const cmds = [
      `git config user.name "github-actions[bot]"`,
      `git config user.email "41898282+github-actions[bot]@users.noreply.github.com"`,
      `git add --all`,
      `git commit -m "Updated at ${new Date().toISOString()}"`,
      `git push`,
    ];

    for (const cmd of cmds) execSync(cmd, "pipe", CONFIG.tmpDir);
  } else {
    logger.info("Not Updated");
  }
}

function updateInstall() {
  const installUrl = `${isDebug ? "https://ghproxy.com/" : ""}https://raw.githubusercontent.com/Homebrew/install/master/install.sh`;
  execSync(`curl -fsSLO ${installUrl}`, "pipe", rootDir);
  const content = fs
    .readFileSync("install.sh", "utf8")
    .replaceAll("https://github.com/Homebrew/", "https://ghproxy.com/github.com/Homebrew/");
  fs.writeFileSync("install.sh", content, "utf8");
}

function outputSources() {
  logger.debug("starting output for", CONFIG.sourcesStatFile);

  const list = [...destFilesCache.values()]
    .sort((a, b) => a.src > b.src)
    .map((item) => `${(item.src.replace(CONFIG.tmpDir), "")}, ${item.repo}, ${item.fixed ? 1 : 0}`);
  if (list.length > 0) fs.writeFileSync(CONFIG.sourcesStatFile, list.join('\n'), "utf8");
}

async function sync() {
  const stats = {
    sync: { Formula: 0, Casks: 0 },
    repo: { abc: 0 },
  };

  updateInstall();
  if (isCI) [...Object.keys(stats.sync), "tmp"].forEach((d) => rmrf(d));

  const tmpRbFileDir = path.resolve(CONFIG.tmpDir, "abc");
  mkdirp(tmpRbFileDir);

  for (const repo of CONFIG.repo) {
    logger.info(`sync for ${color.greenBright(repo)}`);

    if (repo.startsWith("http") && repo.endsWith(".rb")) {
      execSync(`curl -fsSLO ${repo}`, "pipe", tmpRbFileDir);
      stats.repo.abc++;
      continue;
    }

    const repoDirName = repo.replaceAll('/', '-');
    await checkout(repo, repoDirName);
    stats.repo[repo] = {};
    for (const fname of Object.keys(stats.sync)) {
      stats.repo[repo][fname] = await syncDir(path.resolve(CONFIG.tmpDir, repoDirName, fname), fname, repo);
      logger.info(` - [synced][${color.green(fname)}]`, stats.repo[repo][fname]);
      stats.sync[fname] += stats.repo[repo][fname];
    }
  }

  stats.sync.Casks += await syncDir(path.resolve(tmpRbFileDir, "Casks"), "Casks", 'abc');

  if (isCI) {
    fs.rmSync(CONFIG.tmpDir, { recursive: true, force: true });
    outputSources();
    gitCommit();
  }

  const fixedCount = [...destFilesCache.values()].filter((d) => d.fixed).length;
  logger.info("Done!", `Total: ${destFilesCache.size}, Fixed: ${fixedCount}`, stats);
}

sync();
