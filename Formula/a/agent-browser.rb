class AgentBrowser < Formula
  desc "Browser automation CLI for AI agents"
  homepage "https://agent-browser.dev/"
  url "https://ghfast.top/https://github.com/vercel-labs/agent-browser/archive/refs/tags/v0.40.0.tar.gz"
  sha256 "f28a4f0b4d5d6eff4925a2b442d5d930c96ed6932f283f014dd120dc1bc174ef"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "070f7fc1265ca225475a135094f41fe249ae38c9d21f550572bb563515548f40"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "47007e2cb1ffe375a85f3f13c6b88f8dcea3e9f8614e694aaa882bf41fb0cfee"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c29950a64c9c50c3c76988732e61423a5f8d4e7b5964cd4f616ca27253b5cddc"
    sha256 cellar: :any,                 arm64_linux:       "dea27f9598adf361f8974dec6415775bac88309e26ec97f61953ac258b0268dc"
    sha256 cellar: :any,                 x86_64_linux:      "e5ed58df8b3be16cf9ac4e37e3472c3e3fee51b95971e6fcc964799fccb78edc"
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