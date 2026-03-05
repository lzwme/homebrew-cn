class AgentBrowser < Formula
  desc "Browser automation CLI for AI agents"
  homepage "https://agent-browser.dev/"
  url "https://registry.npmjs.org/agent-browser/-/agent-browser-0.16.3.tgz"
  sha256 "780aa698169a8610d8aabca54dc2021543c2d0b1cd89e2111258fff1753271d3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "5a30f4a614a6762b74876e56dc39a8ea3b043ba38b60f495ff2e2441f589300f"
    sha256 cellar: :any,                 arm64_sequoia: "678b73162b8d99b6a5f3e456fb979a6d24ea9c11ff880b7104a6d51102f63227"
    sha256 cellar: :any,                 arm64_sonoma:  "678b73162b8d99b6a5f3e456fb979a6d24ea9c11ff880b7104a6d51102f63227"
    sha256 cellar: :any,                 sonoma:        "1156d5f34ad5755653d8e4881564ecb90f96e1b50b305a200c1ca2c07281be88"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6f0ae5a6c43202df65e898d3f433b459b8c6919b0c6449330e7646b65120e9f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2d6825f6e49c62afc926271071c5da45a5866fa0086b2ff2a475f6745a07973f"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    # Remove non-native platform binaries and make native binary executable
    node_modules = libexec/"lib/node_modules/agent-browser"
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : "arm64"
    (node_modules/"bin").glob("agent-browser-*").each do |f|
      if f.basename.to_s == "agent-browser-#{os}-#{arch}"
        f.chmod 0755
      else
        rm f
      end
    end

    # Remove non-native prebuilds from dependencies
    node_modules.glob("node_modules/*/prebuilds/*").each do |prebuild_dir|
      rm_r(prebuild_dir) if prebuild_dir.basename.to_s != "#{os}-#{arch}"
    end
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