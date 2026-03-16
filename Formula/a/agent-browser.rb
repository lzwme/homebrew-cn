class AgentBrowser < Formula
  desc "Browser automation CLI for AI agents"
  homepage "https://agent-browser.dev/"
  url "https://registry.npmjs.org/agent-browser/-/agent-browser-0.20.12.tgz"
  sha256 "4cd52f8f019a2da54a5bb6d836ab69ca9b412016b421eabec55be901efad7e05"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "adb51202cc85ed4b26e1a65a42ac72292f569b7333d3a4de86026a47d804a0a0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "adb51202cc85ed4b26e1a65a42ac72292f569b7333d3a4de86026a47d804a0a0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "adb51202cc85ed4b26e1a65a42ac72292f569b7333d3a4de86026a47d804a0a0"
    sha256 cellar: :any_skip_relocation, sonoma:        "3e1e31f2a3d12b07ade28dcb08c3fd37eab250dd906435351ea36b8d5a6f39c6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "54bf9be1786cb5afb8a46444fc257db01b3f3ffcff609bc744da1503d11e7661"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2f768d49779b9b49b958483c61b548377825693e96104f0db2410e143cb11fd9"
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