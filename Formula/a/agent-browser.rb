class AgentBrowser < Formula
  desc "Browser automation CLI for AI agents"
  homepage "https://agent-browser.dev/"
  url "https://registry.npmjs.org/agent-browser/-/agent-browser-0.15.0.tgz"
  sha256 "e1b99d5a3257a832fda6818c0277880229a204f00780b5e3fe04efdda4d3eba4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2ebd2b14bc9bb911a2d8fe611705d6158246e9c171e6ee2ec60cb86121d33658"
    sha256 cellar: :any,                 arm64_sequoia: "904f07a9904035140783077dc2f20ba0209ca4b28d55ddaa3ef0da32fc90566d"
    sha256 cellar: :any,                 arm64_sonoma:  "904f07a9904035140783077dc2f20ba0209ca4b28d55ddaa3ef0da32fc90566d"
    sha256 cellar: :any,                 sonoma:        "976bf7e77e9ce8039d60458751fb83c8a92bc55509f40ad9e821a94a1ac76fea"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2f9ae297922578201051d9da1939589662b12b6cdaf45ddfd89cd0fd61fc8398"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b877043fe5cc7b4884095e3094729c58b60e50a4b203f8df036fb24c65a4986a"
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