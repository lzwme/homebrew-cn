class AgentBrowser < Formula
  desc "Browser automation CLI for AI agents"
  homepage "https://agent-browser.dev/"
  url "https://ghfast.top/https://github.com/vercel-labs/agent-browser/archive/refs/tags/v0.35.1.tar.gz"
  sha256 "b2eb23e3e04f4e2768b5d97c10c464fc723851650633f049e6b936876a076b61"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8aef32d69881ae5dba85382c46eb0a26cb58a3756350ea33de0dd8162ddfd463"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1d120ba56cfac69d2245943c5bb0da0ade72626eb7f89b9cbe724c97fdc76848"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0fec1d5914c4f9884391211499e1467b3e68d2087e611dc39acc44040d7f9e08"
    sha256 cellar: :any_skip_relocation, sonoma:        "faca5b016f8aa234333815f12bbcee647ec3c95f13d650a93edfadfa9a3bcfd6"
    sha256 cellar: :any,                 arm64_linux:   "b0a69378df95503ad5b53ab429885384aa537ab22a15370976081b0ea179fad1"
    sha256 cellar: :any,                 x86_64_linux:  "8723f7c9c0b2c1088532e0620f42a14fef49266e3468d9ced7de0b917e26de2a"
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