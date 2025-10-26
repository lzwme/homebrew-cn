class VibeLogCli < Formula
  desc "CLI tool for analyzing Claude Code sessions"
  homepage "https://vibe-log.dev/"
  url "https://registry.npmjs.org/vibe-log-cli/-/vibe-log-cli-0.7.2.tgz"
  sha256 "830ce89a5c6863cd8712f83b26b9924485789fdc3a8359a6ef2872cfe85981a7"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "441fb451e5e9ecb74248a229d45bbb4141d19d7489cd1d9485a54a8cdb6d8ea8"
    sha256 cellar: :any,                 arm64_sequoia: "b4bab11e4b314b86f202563b4cfd2ebfdfcbafb19745a5c1aa22c04e81bafe24"
    sha256 cellar: :any,                 arm64_sonoma:  "b4bab11e4b314b86f202563b4cfd2ebfdfcbafb19745a5c1aa22c04e81bafe24"
    sha256 cellar: :any,                 sonoma:        "feb2d5586ce77002cc4f9b7d9d803936635409149b6c2b78b82c183fb62cff3b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ee6e6e3b667cbecc95ed7e9291236899066916f57f5750e9376e0f47f3ddc9fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7472e3f1a5972317e4eb9610240d7186a48c1c605d5a41476e56391e3f381c25"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Remove incompatible pre-built binaries
    ripgrep_vendor_dir = libexec/"lib/node_modules/vibe-log-cli/node_modules/@anthropic-ai/claude-code/vendor/ripgrep"
    rm_r(ripgrep_vendor_dir)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vibe-log --version")
    assert_match "Failed to send sessions", shell_output("#{bin}/vibe-log send --silent 2>&1")
  end
end