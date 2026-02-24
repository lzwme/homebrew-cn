class AgentBrowser < Formula
  desc "Browser automation CLI for AI agents"
  homepage "https://agent-browser.dev/"
  url "https://registry.npmjs.org/agent-browser/-/agent-browser-0.14.0.tgz"
  sha256 "6fbb0f5982c3ac041a2d7a2180bad89cd7dc1c66bd88bc15e1b7cdc07ad39c6d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f57cc5ba8d62d21880e3fa9e8665cdd5bf5272e80bf9b14581f484b4231644de"
    sha256 cellar: :any,                 arm64_sequoia: "26dd06f965ca9815dc7e8eb9d8fe0f5fc844f89f0531b6f65e2660788fde1d1e"
    sha256 cellar: :any,                 arm64_sonoma:  "26dd06f965ca9815dc7e8eb9d8fe0f5fc844f89f0531b6f65e2660788fde1d1e"
    sha256 cellar: :any,                 sonoma:        "f5dbe58dbf0cebd279e1b0803c3ce3abaf5d32c1a75319ec9a969fb91a1630c2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "633f9b5b61aa6100664df260231d995211f57e34160e2f3dda3b075a31657956"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "efaabbb9be783e3c148056e6a1c7b37670d326654c830a56a32e413cda1e8bec"
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