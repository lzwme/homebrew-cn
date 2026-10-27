class AgentBrowser < Formula
  desc "Browser automation CLI for AI agents"
  homepage "https://agent-browser.dev/"
  url "https://ghfast.top/https://github.com/vercel-labs/agent-browser/archive/refs/tags/v0.39.4.tar.gz"
  sha256 "3c2a46ff1f89ef1d14c8ee2f5b5521336b9cf48208475cccb0958ed5ec56ea44"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1f77547fa2cdb0a54601390f4bb8f1ce863c60e37705fa7465372e02f4214a59"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "072ec1e27c6875e7417963358d5532025ab40ac4b808456507d6740deea01f4b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "18c2fb3fc79b8bec77b698e76318c7e06bc9f6758315a40d60fe8ffc1795df18"
    sha256 cellar: :any,                 arm64_linux:       "985cd15f805a344f0dfa0abeaf376ffcbd91ccf817f9f1708f5bbe0337fb144e"
    sha256 cellar: :any,                 x86_64_linux:      "57efd76878e04b42f9cad345c8d972e9b57bada1038eb0a948a29bf5d9a520aa"
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