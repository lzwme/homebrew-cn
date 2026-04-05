class AgentBrowser < Formula
  desc "Browser automation CLI for AI agents"
  homepage "https://agent-browser.dev/"
  url "https://registry.npmjs.org/agent-browser/-/agent-browser-0.24.1.tgz"
  sha256 "49234c2855910741020b598580dff5c687ca63c2371a7364274acd519048d22c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "602ae27ec417f3265e8bdb9b9324209a92ba8e18a5804b682935fb83a350467f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "602ae27ec417f3265e8bdb9b9324209a92ba8e18a5804b682935fb83a350467f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "602ae27ec417f3265e8bdb9b9324209a92ba8e18a5804b682935fb83a350467f"
    sha256 cellar: :any_skip_relocation, sonoma:        "fb76c3833dd7fd023ec588575616814f0d1b73e4470979263ac2f5890ee5da49"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e162fa44b5202b10c2620568d0538393af7a2b79607ddfafa613601c7d832825"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2c1f6bf108c28a9f596cbfa15ae54abb2f295cf8582cc06283182ed1121f38d4"
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