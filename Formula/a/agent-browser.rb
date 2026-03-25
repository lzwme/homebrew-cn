class AgentBrowser < Formula
  desc "Browser automation CLI for AI agents"
  homepage "https://agent-browser.dev/"
  url "https://registry.npmjs.org/agent-browser/-/agent-browser-0.22.2.tgz"
  sha256 "bbdf08a19bdf817055d119b41e0b6e79096c632d3638fc79972f7668f71bb391"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1b7d02d22f5f5416827dbc0351bb3a098c8aabea695267f52b0242f10a2c3dd8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1b7d02d22f5f5416827dbc0351bb3a098c8aabea695267f52b0242f10a2c3dd8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1b7d02d22f5f5416827dbc0351bb3a098c8aabea695267f52b0242f10a2c3dd8"
    sha256 cellar: :any_skip_relocation, sonoma:        "83de446c405bd534f2c4fa72af37ff9c398f10a8d8fcde3d813cb45341af9b2e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "745fcc08558710339f2f75a9181d9d784b4b9cd7eb86ea07358b6d4548790123"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "209c3dce0d54751304c43784dbc3900427cc380a3800631ab08ca02c78fa90e8"
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