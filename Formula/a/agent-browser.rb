class AgentBrowser < Formula
  desc "Browser automation CLI for AI agents"
  homepage "https://agent-browser.dev/"
  url "https://ghfast.top/https://github.com/vercel-labs/agent-browser/archive/refs/tags/v0.32.2.tar.gz"
  sha256 "d653eb438195fa0c8107cb8f253be351a081558e020d933a24756328a790f610"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "853ed87483260872f74d052f081fef1d2873f01f0b2681dceaea35f0b37990d6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a9716076de294df9eed31a995fa79d385ec26a4309e87f138d40692eff7a7443"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "35b45edef3eb978e35b8f9065e691e182152a1160b57706d39556fcec37fa94b"
    sha256 cellar: :any_skip_relocation, sonoma:        "11586abf1ef59efc83824869cce0269f15575681af35ab38bcbc37f826a85b77"
    sha256 cellar: :any,                 arm64_linux:   "c78e9f683fc5ad00b18077ea33d7847582befc6a9f205d0294b4ed4501624d4a"
    sha256 cellar: :any,                 x86_64_linux:  "8854936b04b2135f767187022a324a0ca8936c07fafca380f2254b5e2840b74d"
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