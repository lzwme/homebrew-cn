class AgentBrowser < Formula
  desc "Browser automation CLI for AI agents"
  homepage "https://agent-browser.dev/"
  url "https://ghfast.top/https://github.com/vercel-labs/agent-browser/archive/refs/tags/v0.31.2.tar.gz"
  sha256 "16423e6b416c0b3c1ad39b7e2f8709b191aa30cd325e585888a2d64d525c7e2f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c4f62428536c8a8f39756e8ca69bf8f1c7e0d27b40fda5d9c7d9f69d96125d0b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4bbe2424b9099388d72039fb31a9911b4e390f7fa7da4b4d0721dff6061312ad"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "85c2865b1ea1cc62b3eebdbd9db1cb21ada5627f66e06652c09537c19ec6f8d3"
    sha256 cellar: :any_skip_relocation, sonoma:        "42f8c3d03b81baad0714f4d44e1a29e7574a651fe46ab39dcd335ed98fa7f703"
    sha256 cellar: :any,                 arm64_linux:   "eab5b20c7559518161c389eb0079e713f002abcf1986a02d5d8cd3f3382882c2"
    sha256 cellar: :any,                 x86_64_linux:  "ff68b31c19fbb39ecabcce2972b07d04026edb19dd068e1a0467f9056afbf80a"
  end

  depends_on "rust" => :build
  depends_on "node"

  deny_network_access! [:postinstall, :test]

  def install
    system "npm", "run", "build:native"
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  def caveats
    <<~EOS
      To complete the installation, run:
        agent-browser install
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/agent-browser --version")

    # Verify session list subcommand works without a browser daemon
    assert_match "No active sessions", shell_output("#{bin}/agent-browser session list")

    # Verify CLI validates commands and rejects unknown ones
    output = shell_output("#{bin}/agent-browser nonexistentcommand 2>&1", 1)
    assert_match "Unknown command", output
  end
end