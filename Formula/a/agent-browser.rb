class AgentBrowser < Formula
  desc "Browser automation CLI for AI agents"
  homepage "https://agent-browser.dev/"
  url "https://ghfast.top/https://github.com/vercel-labs/agent-browser/archive/refs/tags/v0.33.2.tar.gz"
  sha256 "471db51eebc4f2b1f9cd817020f2f50b2a8370f6f8611b9a29caf8d3bbb146a3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c7c83fc761016b0f93a302b5fd35883ef93aae73dc35855ba0be8751337faec6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e500ad5f310c0a492ccd6428dc544586e8839eb9a37c7c1be5aec618f36d242f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "41e07daabe21170a6e5799fa69448ebd6b47c31ea5f0e6e134e4bfe8e75000f0"
    sha256 cellar: :any_skip_relocation, sonoma:        "c389548883822946b1c68a8175c35e9980d0f012a093f4327f75bc3b1e87af3d"
    sha256 cellar: :any,                 arm64_linux:   "096ed5ae74714ebd0dbfe601485ed0823060c614a03cfc7c7d9b77826f812c27"
    sha256 cellar: :any,                 x86_64_linux:  "a09640e114994a83284ec78f788fcfec255740864721e11c17f94a7e3d6ac4c4"
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