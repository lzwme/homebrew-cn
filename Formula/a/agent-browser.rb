class AgentBrowser < Formula
  desc "Browser automation CLI for AI agents"
  homepage "https://agent-browser.dev/"
  url "https://registry.npmjs.org/agent-browser/-/agent-browser-0.22.0.tgz"
  sha256 "a7322961d54f262e9ae4995c5734dd0d301f1ea52f2b1c7bcd599c2854a3bcfa"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "30539497f7b46c4be4a30556c2c4eb631ba578e023cf91d555120b9890be276c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "30539497f7b46c4be4a30556c2c4eb631ba578e023cf91d555120b9890be276c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "30539497f7b46c4be4a30556c2c4eb631ba578e023cf91d555120b9890be276c"
    sha256 cellar: :any_skip_relocation, sonoma:        "d3bb20b2a53828e6c21d40a6c4725f5a724eda9d15d07ca4f6de609fb211b605"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "acc2a1524243b50b113d8b0add05adb887601ea7ed695d0411dc3c0149c87a26"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5daed088ef1d169c7abe6f93a7a84c6aeee8d91e0a5cd31a66567905bf15c668"
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