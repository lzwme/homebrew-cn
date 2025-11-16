class VibeLogCli < Formula
  desc "CLI tool for analyzing Claude Code sessions"
  homepage "https://vibe-log.dev/"
  url "https://registry.npmjs.org/vibe-log-cli/-/vibe-log-cli-0.8.1.tgz"
  sha256 "696d21e735879dfce011849720afffb8ca122681403a2c47f94e7931a76362e0"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9d4e89f261794ab3695d6e3f2756beb34eaa251c54b00b0e7fa8a1a86821b8a3"
    sha256 cellar: :any,                 arm64_sequoia: "3f05d4ea2ce185cc7ae126c9f10c0530e941fb7970d67c8186dcb74e261755c1"
    sha256 cellar: :any,                 arm64_sonoma:  "3f05d4ea2ce185cc7ae126c9f10c0530e941fb7970d67c8186dcb74e261755c1"
    sha256 cellar: :any,                 sonoma:        "b288069aa7a1afb08c847e5fd997465db640794ff1f419479baa737d77c28a0a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e318039395509789c364676933e7ffe956f3a7eb05329be25631269fe687da81"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c930b5627d45c74871a6b126d88d45dd08c7456dc914ee68dbd5c07834a10d67"
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