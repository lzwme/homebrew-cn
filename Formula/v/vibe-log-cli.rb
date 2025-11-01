class VibeLogCli < Formula
  desc "CLI tool for analyzing Claude Code sessions"
  homepage "https://vibe-log.dev/"
  url "https://registry.npmjs.org/vibe-log-cli/-/vibe-log-cli-0.7.5.tgz"
  sha256 "e9dc1e81205e44ed87f52350b7f99025ad0eeffd9f56ca896365fa1cb1139aa4"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "dd02a765fcfa5638fa84c7ef83dc7f09c09517e0fb90fd79a824d90c00910019"
    sha256 cellar: :any,                 arm64_sequoia: "06ce7d5ac3d456cb880154df538719aa28ed9c7ffe064a5cb72299db719a7bdc"
    sha256 cellar: :any,                 arm64_sonoma:  "06ce7d5ac3d456cb880154df538719aa28ed9c7ffe064a5cb72299db719a7bdc"
    sha256 cellar: :any,                 sonoma:        "04881a3f89f67b9ff8c2cd5c4c40e15b6d37c0b6598408d77d852e120e31f1ab"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2c78004c627b3b4726f05980c4a02dc21e9f981662e799b5e50984810d4abe6e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "db53c03747380854e656c6b8ecfc81cf306f0439761034c33d10786b81aff09d"
  end

  depends_on "node"

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