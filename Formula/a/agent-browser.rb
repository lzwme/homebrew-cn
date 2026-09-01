class AgentBrowser < Formula
  desc "Browser automation CLI for AI agents"
  homepage "https://agent-browser.dev/"
  url "https://ghfast.top/https://github.com/vercel-labs/agent-browser/archive/refs/tags/v0.35.2.tar.gz"
  sha256 "e0bc920de68083ca581794d1210ea1374c7bdc5fab8bd122c81b1cade8669cff"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "739ac3c7f63c11f241dd55b3b877e4edc826e5568b29a535fbcfe86d52add573"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fb8519cfab53c36a6ec730e459cfc76f645505032e27d487c8210b2173931d3d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e924f4e55aa5aab0aa7a2d5e8958df939faa0524415334676f62c745662afa06"
    sha256 cellar: :any,                 arm64_linux:   "30c64f58dd722d0c24d2f05b47c7228dff338b6e9e2a4eec89720961256dbe7d"
    sha256 cellar: :any,                 x86_64_linux:  "ad79a20b0787e9ab106c3df84ad5008b22058a295368ae018d1c6fbb4406bc53"
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