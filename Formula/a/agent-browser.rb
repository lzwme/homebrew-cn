class AgentBrowser < Formula
  desc "Browser automation CLI for AI agents"
  homepage "https://agent-browser.dev/"
  url "https://registry.npmjs.org/agent-browser/-/agent-browser-0.19.0.tgz"
  sha256 "2157ee9948684fc102940c90bdc90893e9721c19a9c42212d4dcbab6ef9a21f9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6a162205a691f02afb1a4c8496aa5ae2d8550e3e5737b76eb43bae24e1d4c872"
    sha256 cellar: :any,                 arm64_sequoia: "6b631d825149bb5d046a143580b2a3c3e3e8ad517449a242eb499a5b7ea4b823"
    sha256 cellar: :any,                 arm64_sonoma:  "6b631d825149bb5d046a143580b2a3c3e3e8ad517449a242eb499a5b7ea4b823"
    sha256 cellar: :any,                 sonoma:        "fdd2052a1db3ea74d6b0f57122fa2b74c08bd690b24c69dda8d59619e7ab5ab0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5cdedac68fbc70cd2f82cda110ab4ffb630929f06e94b606377de7e3cf82293b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d6e1f78e03a6ef578658c59e39563e820da0a63cbad5c90751695a5a41831029"
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