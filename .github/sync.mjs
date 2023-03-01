
import { execSync } from "node:child_process";
import fs from "node:fs";
import path from "node:path";
import { semverCompare, getRBVersion } from "./utils.mjs";

const isDebug = process.argv.slice(2).includes("--debug");
const isCI = process.env.SYNC != null;
const rootDir = process.cwd();
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
  ],
  filter: /\.gitkeep|__/,
  syncExt: new Set([".rb", ".sh"]), // 允许同步的文件类型
  onlySyncFixed: true, // 是否仅同步内容被修正过的文件
  lowPriority: parseBucketPriorityFile(),
};
const destFilesCache = new Map();

function parseBucketPriorityFile(filename = "low-priority.txt") {
  const str = fs.readFileSync(path.resolve(rootDir, filename), "utf8").trim();
  const list = str
    .split("\n")
    .slice(1)
    .filter((d) => d.includes("/"))
    .map((d) => path.resolve(CONFIG.tmpDir, d.replace("/", "-").replace(", ", "/")));

  return new Set(list);
}

async function checkout(repo, dirName) {
  if (!fs.existsSync(CONFIG.tmpDir)) fs.mkdirSync(CONFIG.tmpDir);

  try {
    const dirpath = path.resolve(CONFIG.tmpDir, dirName);
    if (fs.existsSync(dirpath)) {
      execSync(`cd "${dirpath}" && git pull`, { cwd: CONFIG.tmpDir });
    } else {
      repo = isDebug ? `https://ghproxy.com/https://github.com/${repo}` : `https://github.com/${repo}.git`;
      execSync(`git clone --depth 1 ${repo} ${dirName}`, { cwd: CONFIG.tmpDir });
    }
  } catch (error) {
    console.error(`checkout ${repo} failed!`, error.message);
  }
}

async function syncDir(src, dest, repo = "") {
  let total = 0;
  const basename = path.basename(src);

  if (!fs.existsSync(src) || CONFIG.filter.test(basename)) return total;

  const stats = fs.statSync(src);
  const ext = path.extname(src).toLowerCase();

  if (stats.isFile()) {
    if (!CONFIG.syncExt.has(ext)) return total;

    const destLowerCase = String(dest).toLowerCase();
    let content = "";

    if (destFilesCache.has(destLowerCase)) {
      if (".rb" !== ext || CONFIG.lowPriority.has(src)) return total;

      dest = destFilesCache.get(destLowerCase).dest; // 使用旧路径
      try {
        content = fs.readFileSync(src, "utf8").trim();
        const destVersion = getRBVersion(fs.readFileSync(dest, "utf8"));
        if (semverCompare(getRBVersion(content), destVersion, false) < 1) return total;
      } catch (e) {
        console.error("[error]try compare version failed!", src, dest, e.message);
        return total;
      }
    }
    destFilesCache.set(destLowerCase, { dest, src: src.slice(CONFIG.tmpDir.length + 1), repo });

    if ([".rb", ".sh"].includes(ext)) {
      if (!content) content = fs.readFileSync(src, "utf8");
      const rawContent = content;

      if (".rb" === ext) {
        content = content.replaceAll("\r\n", "\n").trim();
      }

      if (basename.startsWith("node")) {
        content = content.replace(/(https:\/\/nodejs\.org\/dist\/)/gim, "https://registry.npmmirror.com/-/binary/node/");
      } else if (content.includes("github.com") || content.includes("githubusercontent.com")) {
        content = content
          .replace(/(https:\/\/github\.com.+\/releases\/download\/)/gim, "https://ghproxy.com/$1")
          .replace(/(https:\/\/github\.com.+\/archive\/)/gim, "https://ghproxy.com/$1")
          .replace(/(https\:\/\/(raw|gist)\.githubusercontent\.com)/gim, "https://ghproxy.com/$1")
          .replaceAll("https://ghproxy.com/https://ghproxy.com", "https://ghproxy.com");
      }

      if (CONFIG.onlySyncFixed && rawContent === content) return total;

      fs.writeFileSync(dest, content, "utf8");
    } else {
      fs.writeFileSync(dest, fs.readFileSync(src));
    }

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
  const changes = execSync("git status --short", { encoding: "utf8" }).trim(); // --untracked-files=no
  if (changes.length > 5) {
    console.log("Changes:\n", changes);
    const cmds = [
      `git config user.name "github-actions[bot]"`,
      `git config user.email "41898282+github-actions[bot]@users.noreply.github.com"`,
      `git add --all`,
      `git commit -m "Updated at ${new Date().toISOString()}"`,
      `git push`,
    ];

    for (const cmd of cmds) execSync(cmd, { encoding: "utf8", maxBuffer: 1024 * 1024 * 100 });
  } else {
    console.log("Not Updated");
  }
}

function updateInstall() {
  const installUrl = `${isDebug ? "https://ghproxy.com/" : ""}https://raw.githubusercontent.com/Homebrew/install/master/install.sh`;
  execSync(`curl  -fsSLO ${installUrl}`);
  fs.readFileSync("install.sh", "utf8").replaceAll("https://github.com/Homebrew/", "https://ghproxy.com/github.com/Homebrew/");
}

async function sync() {
  updateInstall();
  if (isCI) {
    ["Formula", "Casks", "tmp"].forEach((d) => fs.existsSync(d) && fs.rmSync(d, { recursive: true, force: true }));
  }

  let bucketFiles = 0;

  for (const repo of CONFIG.repo) {
    const repoDirName = repo.replaceAll("/", "-");
    console.log(`sync for \x1B[32m${repo}\x1B[39m`);
    await checkout(repo, repoDirName);
    const tapCount = await syncDir(path.resolve(CONFIG.tmpDir, repoDirName, "Formula"), "Formula", repo);
    const caskCount = await syncDir(path.resolve(CONFIG.tmpDir, repoDirName, "Casks"), "Casks", repo);
    if (tapCount || caskCount) {
      bucketFiles += tapCount + caskCount;
    } else {
      console.warn(`[warn][synced nothing]`, repo);
    }
  }

  if (isCI) {
    fs.rmSync(CONFIG.tmpDir, { recursive: true, force: true });
    gitCommit();
  }

  console.log("Done!", bucketFiles, scriptsFiles, `Total: ${destFilesCache.size}`);
}

sync();
