class AgentBrowser < Formula
  desc "Browser automation CLI for AI agents"
  homepage "https://agent-browser.dev/"
  url "https://ghfast.top/https://github.com/vercel-labs/agent-browser/archive/refs/tags/v0.37.1.tar.gz"
  sha256 "704f4c3fdc7bc2f64a6674b12d0f0d81f71f33d54e23aad82eabe073735a9362"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "179ea9e71fce9f8a398689325f3db9efa8708afbff07b509d07e747f3b0e79f8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c79a2f84ebf40735778aae2d4527eac643a27d739feff26c60cdb59650569bd0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3c6aa0f7637b0c3f21b3d8eb67b728225b0d0520a21f3eb34730d9f3c360da9e"
    sha256 cellar: :any,                 arm64_linux:   "f9843c533b0bc49535b73138a98773ce6c6ecefec5bb44adf6620daf3d52a6ec"
    sha256 cellar: :any,                 x86_64_linux:  "8a38b1653c4229a703ab8ef2b3f39e971fe9c2216d0693225ea1bccdd7678154"
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