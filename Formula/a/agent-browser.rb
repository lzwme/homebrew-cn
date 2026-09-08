class AgentBrowser < Formula
  desc "Browser automation CLI for AI agents"
  homepage "https://agent-browser.dev/"
  url "https://ghfast.top/https://github.com/vercel-labs/agent-browser/archive/refs/tags/v0.37.0.tar.gz"
  sha256 "b0fd8619baaa4c3cf9bb13ac2cd06159311addf2f1e2b1313b06e479c80cf631"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e8e9caba4a93898eb49c77b8a705e72ce89986ce0692dca5d9f52cf0567791b5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aac437591bdfc92b51dfa339f621a7e4e187623cf0e7c025bc5ebd3443670e83"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bb586005bdf1dcf31025bac35edbd7c4e6ec922b06511be47bb450c94b1c5973"
    sha256 cellar: :any,                 arm64_linux:   "5cd63db3ab576efc4af661502c0ce08d5301a7756be5dd2dcb54c4a61fd68d44"
    sha256 cellar: :any,                 x86_64_linux:  "da11a38d3191446be96c94b5f463807e1dbe3746827e9e8bcdfd4b5d86de8ccc"
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