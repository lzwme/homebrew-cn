class AgentBrowser < Formula
  desc "Browser automation CLI for AI agents"
  homepage "https://agent-browser.dev/"
  url "https://ghfast.top/https://github.com/vercel-labs/agent-browser/archive/refs/tags/v0.31.0.tar.gz"
  sha256 "51d85146c278337b317867f09052b79e600d6e8abbcc4d8030bb045aab23cda0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f51cfe641004950b0c51b102e585344fa7f656d007c93f9f488e520848d67c8d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "805261fbe284092b4692cc65683a9e0cd7103a2886cdd22c5c6941cd846a5854"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "32e30e0bc9566318b6f69d490b35f5fe837e5c8b49e55b6ba3230d3405c51747"
    sha256 cellar: :any_skip_relocation, sonoma:        "744bf817c3af55b88aa85e4cd02fd3bb8917040c209fede2269ed6c422b38fd3"
    sha256 cellar: :any,                 arm64_linux:   "d553fe025fa3fc4e727dcb9c649d91e0420b00df7d1337803ef2605278747291"
    sha256 cellar: :any,                 x86_64_linux:  "d8b5810e0e170d023c2436f0892edd5f7d29aa92c684305c4955e082e7941967"
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