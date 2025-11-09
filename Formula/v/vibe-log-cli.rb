class VibeLogCli < Formula
  desc "CLI tool for analyzing Claude Code sessions"
  homepage "https://vibe-log.dev/"
  url "https://registry.npmjs.org/vibe-log-cli/-/vibe-log-cli-0.8.0.tgz"
  sha256 "01308991ab3ad3544520a594fa992ebc46b9d01e2b64e9936e936dbd79e27080"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "bc8f85f16c34022756ebedbe517e078efe8438d1ae17b9a512cf3feb4c1ee9b0"
    sha256 cellar: :any,                 arm64_sequoia: "0aff332b1ac0c1d24fe08117fa8c9725c66f4cf568d99d54109ac9360c900c39"
    sha256 cellar: :any,                 arm64_sonoma:  "3c0d5c190fe8181e0f0b053b1df8daa74707c209adfd9c7fbdd0abaf3e883b4b"
    sha256 cellar: :any,                 sonoma:        "5f8eca6083af9a6d21d9da0a38743321dec170dbee4ec9649ca2926b6306545f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "66254fff47f4749edeca00df3b732fd5a3af35d4174992d112260930d783f455"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f38762695f9c780f1ed3d01ed72ef558d1c08ce8ef8dc794689a0371c73872a2"
  end

  # `better-sqlite3` needs to be built with `c++17`, but `node` v25  compile with `c++20` by default
  # Issue ref: https://github.com/WiseLibs/better-sqlite3/issues/1411
  depends_on "node@24"

  on_linux do
    depends_on "xsel"
  end

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Remove incompatible pre-built binaries
    vendor_dir = libexec/"lib/node_modules/vibe-log-cli/node_modules/@anthropic-ai/claude-agent-sdk/vendor/ripgrep"
    rm_r(vendor_dir)

    clipboardy_fallbacks_dir = libexec/"lib/node_modules/#{name}/node_modules/clipboardy/fallbacks"
    rm_r(clipboardy_fallbacks_dir) # remove pre-built binaries
    if OS.linux?
      linux_dir = clipboardy_fallbacks_dir/"linux"
      linux_dir.mkpath
      # Replace the vendored pre-built xsel with one we build ourselves
      ln_sf (Formula["xsel"].opt_bin/"xsel").relative_path_from(linux_dir), linux_dir
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vibe-log --version")
    assert_match "Failed to send sessions", shell_output("#{bin}/vibe-log send --silent 2>&1")
  end
end