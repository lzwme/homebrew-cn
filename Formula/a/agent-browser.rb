class AgentBrowser < Formula
  desc "Browser automation CLI for AI agents"
  homepage "https://agent-browser.dev/"
  url "https://ghfast.top/https://github.com/vercel-labs/agent-browser/archive/refs/tags/v0.35.0.tar.gz"
  sha256 "ea4331fae4ddbc1d787908011347234d5ddb88ec920dec7c7240801a9687d04a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ffc619ac94f05cabac74069055b21a37b4eef9b0208a8c02af65b940fb21c9c0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4b013fd19608b0bae0a9631b1b13d695ab3bbe0aa085df3af63554945c99fe4e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1d17f9620dd0f5b2767d9d77bfc8ee268b7c05251b283706b7afdff8b940fd61"
    sha256 cellar: :any_skip_relocation, sonoma:        "a17cf85bb326dff41d89efc302c830e218fa027cd528bdce437a3a09d832d59d"
    sha256 cellar: :any,                 arm64_linux:   "e9cd3efce1d86ad9cc081148f509a721d2a58c55951513dccef7226d9e9db7f3"
    sha256 cellar: :any,                 x86_64_linux:  "c8fca79ddba08a4fb9bf27b01c19ef685e2162f51727fe02722c12e7b37bfae3"
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