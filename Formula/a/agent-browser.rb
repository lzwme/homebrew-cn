class AgentBrowser < Formula
  desc "Browser automation CLI for AI agents"
  homepage "https://agent-browser.dev/"
  url "https://ghfast.top/https://github.com/vercel-labs/agent-browser/archive/refs/tags/v0.32.3.tar.gz"
  sha256 "bba7e2e86c10d27087ec66cee130f02b23966fc3644febcc301f14b4322933d3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8a100c9355dd5269f10073a98893d09dbd5af87ee3afe3f1c1233f0f86da9214"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d575a5b226d8f395448dde34d87935de2d57fbac44911a3d079ba44ac380ca73"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "80a2fce2ed89b685791acbadd837643755735b004352307e25d5a76fa6321457"
    sha256 cellar: :any_skip_relocation, sonoma:        "d33969f0692c1c3e001b908be56c67b1e3071ecfcc8900781225b60d78a7e11c"
    sha256 cellar: :any,                 arm64_linux:   "d451e728481579317b8b2754e35251fab17792f44779e894870417067ae6b203"
    sha256 cellar: :any,                 x86_64_linux:  "e46273241a048899789520123039ae89d58cdbe4589c5b6e78908a221e7e8536"
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