class AgentBrowser < Formula
  desc "Browser automation CLI for AI agents"
  homepage "https://agent-browser.dev/"
  url "https://ghfast.top/https://github.com/vercel-labs/agent-browser/archive/refs/tags/v0.39.2.tar.gz"
  sha256 "0fe13b7e82d81df85b629cfe95229fe7ecc5b4ad14b1c3df7ba56e055216d3bc"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "324640d6184950b21335924137819beb6f9f10c79e595b139930e6316a310d7a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a0612f5946dad25fc0e4e4e5cf9abe54610b693934d74d14b24ee59c0dd19f8b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "07f6650baa919e49372daa88f454525b9bd3ed53043d2036d29ac6afe5f6a4d6"
    sha256 cellar: :any,                 arm64_linux:       "d0c1ebf592135bd7f392f218a5df2ef38a10ebfd2e6a2785ba9f89e645e2568c"
    sha256 cellar: :any,                 x86_64_linux:      "21c190110a5cc2ab87571eed5786d352602ef5fe8f97a4858aa190b440e0b123"
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