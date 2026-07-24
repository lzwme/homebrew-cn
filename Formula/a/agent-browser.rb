class AgentBrowser < Formula
  desc "Browser automation CLI for AI agents"
  homepage "https://agent-browser.dev/"
  url "https://ghfast.top/https://github.com/vercel-labs/agent-browser/archive/refs/tags/v0.33.0.tar.gz"
  sha256 "be52658f6e5781c62b991d25c9650b273d95bd0e60593eeff6e8b6cd974258ef"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5ea337410fd4d3a47fdbc10702beccc5f64bfd849bc219458c3a6ecec3414002"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "43ca88e7f1be7d624d2a2bb82da593d6574a29abae040c1c8016bde51d04326d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c5e5ddfc3dc18c6c58b0fc692f6b8481696d9942a9b5df6503d93abad6ed3bb7"
    sha256 cellar: :any_skip_relocation, sonoma:        "b87c58ade8a35bc2132f752a93c60c325d3f8d25096c3df8901d5ec4faa4c8ac"
    sha256 cellar: :any,                 arm64_linux:   "1f902a4e200ba409c23995f4c7c9e2ecd4ddd3782c17d483a1694b002321df4c"
    sha256 cellar: :any,                 x86_64_linux:  "e8be0b4616ee08808878a1f453ce6a4902ae1aad1619425c39ba50daf364969a"
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