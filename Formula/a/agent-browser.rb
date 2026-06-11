class AgentBrowser < Formula
  desc "Browser automation CLI for AI agents"
  homepage "https://agent-browser.dev/"
  url "https://ghfast.top/https://github.com/vercel-labs/agent-browser/archive/refs/tags/v0.27.2.tar.gz"
  sha256 "d2462a95626a2b5ec191a4c28ca68883aa91c7aa181730905ad4eb62ee0aae30"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "23fa6f80d88097147c119edee5feaca1ede42f77a3e636cd5903314acc321f48"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "66fad9831594d9efcc2ebada99c766f7b3afd3d04edd3564af20128beeb6799d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ef26c95c499ce903394408da30ecc66f4d29cf2640fc4f8f8a35d6fc8cf4a0ce"
    sha256 cellar: :any_skip_relocation, sonoma:        "c71a5d889cbe264ed5dd47bc7c53311d65e53ed8853e67c2656987647baa01d2"
    sha256 cellar: :any,                 arm64_linux:   "7c9beeb6e2b4613b2c08de0dd186d4284c076b37117901a7d44b4fbb99f32528"
    sha256 cellar: :any,                 x86_64_linux:  "ea5ee114a8b737d7f869a7837500921aa7ae27317d6c7505b41cecb4560e7952"
  end

  depends_on "rust" => :build
  depends_on "node"

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