class VibeLogCli < Formula
  desc "CLI tool for analyzing Claude Code sessions"
  homepage "https://vibe-log.dev/"
  url "https://registry.npmjs.org/vibe-log-cli/-/vibe-log-cli-0.7.3.tgz"
  sha256 "d6eaca7886fc97aedf93857f47c5158a72bffb58a0b37a09f6591449a6ebe11a"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c231d326670398d397ff3153ce5e23f9908fd264ace8f9bef80045b7d5e02a2b"
    sha256 cellar: :any,                 arm64_sequoia: "c4810dd59fbfee745729f6a3387d63aa62bcc90fdb7aeb772e6a9fb260a96e82"
    sha256 cellar: :any,                 arm64_sonoma:  "c4810dd59fbfee745729f6a3387d63aa62bcc90fdb7aeb772e6a9fb260a96e82"
    sha256 cellar: :any,                 sonoma:        "8329062b20a68f217da43756c5c83cfdab42b5d4da7aabf2e3e4d4f93c67c965"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d9f2e12bd9f51d952c3ae76431c60163a8c37d9895cb54ffe4e8acaeba764461"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "358b0d4d6d4bd5e1a9b3751811e2444d6038acf07737021ad4ebc0a577ec31a9"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Remove incompatible pre-built binaries
    vendor_dir = libexec/"lib/node_modules/vibe-log-cli/node_modules/@anthropic-ai/claude-agent-sdk/vendor/ripgrep"
    rm_r(vendor_dir)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vibe-log --version")
    assert_match "Failed to send sessions", shell_output("#{bin}/vibe-log send --silent 2>&1")
  end
end