class AgentBrowser < Formula
  desc "Browser automation CLI for AI agents"
  homepage "https://agent-browser.dev/"
  url "https://ghfast.top/https://github.com/vercel-labs/agent-browser/archive/refs/tags/v0.36.0.tar.gz"
  sha256 "d414015852de0165c46a5adbf041592ddf32ee790d749061faef6cb43c1d3c59"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f45270f59138e5fc7c6fe9bae73d3590476efdc2710d79f080d8266dec727697"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "87ffc1e5d4ddf6ceff66d08feb58bee768a59be5e993779b6b846148b9cc0776"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "309d53a0c82eae516527d0ff4e74100e8fd278db800a7067313f5355d5b1a80d"
    sha256 cellar: :any,                 arm64_linux:   "fd94678454fdcd3c9a44a1d8ffa18f86e77288e4f319b4b6fc36f8eafd6d74ca"
    sha256 cellar: :any,                 x86_64_linux:  "7ec02c2279a80e1bcdce620d817506fc951a9f588215f866c2e1b6324698e76b"
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