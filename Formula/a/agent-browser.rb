class AgentBrowser < Formula
  desc "Browser automation CLI for AI agents"
  homepage "https://agent-browser.dev/"
  url "https://ghfast.top/https://github.com/vercel-labs/agent-browser/archive/refs/tags/v0.32.1.tar.gz"
  sha256 "a63703b7a38f695df69f7a5dc25f0762ea32b0ca6794ae830b1591b7217c649c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "95ee17f922abe6c34a19b81c52de2fdc5ed2cffe625b52ac32da95e7a22f6207"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "64d20555ac2395c4013c2242d617d9c26fb7541fd3f082725ac0068539f38cd8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a92fcaa0563658d9cd4d4f9d224ff29372c5ab23e697af2f88b65afc395602df"
    sha256 cellar: :any_skip_relocation, sonoma:        "874f82610b8721a6e39972f55f84e6e4bc1cadce4529ffe9c7b79864862dfeff"
    sha256 cellar: :any,                 arm64_linux:   "3b0d34236961fb560840c54f8027f11acc7139a0476721128078133c0c91cd2c"
    sha256 cellar: :any,                 x86_64_linux:  "3173be574ab2808f678ffcfbdcee0c85c3a76198a7231fdb4a073ed5cb6fd1ab"
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