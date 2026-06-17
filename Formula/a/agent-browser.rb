class AgentBrowser < Formula
  desc "Browser automation CLI for AI agents"
  homepage "https://agent-browser.dev/"
  url "https://ghfast.top/https://github.com/vercel-labs/agent-browser/archive/refs/tags/v0.28.0.tar.gz"
  sha256 "6d8e38eaca9294c7f23f556f34df084e89535417e547489476a1a5582a2824a5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "366f1f879a5e2684bd37a79f6b5268b03830b7793bae192e790af112f5bd733a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0f75d475503d5d5fd112874190ce3939a214282208392e8c04c52423f26f25c5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2d633dfa840f36bcad91250e1013b5f2d94d2b06695a8d6adf88fdd0361e5b79"
    sha256 cellar: :any_skip_relocation, sonoma:        "157d93e4923d22e6e590eeda52b201b5f7f70eab198373d9c3aa263a3c27d689"
    sha256 cellar: :any,                 arm64_linux:   "dba96b86cf912c72cb0e78c0185fff205d7f504b1021884b4b9719cde3ecf7d7"
    sha256 cellar: :any,                 x86_64_linux:  "3f193702eede3de8bf29dc05d67988b8c000f70023aedf3d20895eb0f2fc55e7"
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