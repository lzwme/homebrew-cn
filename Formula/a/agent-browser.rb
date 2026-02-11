class AgentBrowser < Formula
  desc "Browser automation CLI for AI agents"
  homepage "https://agent-browser.dev/"
  url "https://registry.npmjs.org/agent-browser/-/agent-browser-0.9.2.tgz"
  sha256 "b475020d0c0782fcb08c5d0fba883505494d19d4ac672857e79282d099b5a067"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "49e3e5a2fb239fcf0bfff66ecc6ac1530fa0306d2953ca12cddcc1148e73d1d5"
    sha256 cellar: :any,                 arm64_sequoia: "738ba0208b4f9857174b7c1e974310d87d2215d2d3e2d1ea7607699b325be19f"
    sha256 cellar: :any,                 arm64_sonoma:  "738ba0208b4f9857174b7c1e974310d87d2215d2d3e2d1ea7607699b325be19f"
    sha256 cellar: :any,                 sonoma:        "5cd333c058372c244fda481655a2b9f6577525c5dd76dd179facca4845805c2a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d8af01e0c7ed4eef136c423a81a29196003b26a0f40330c6656188a01ff3b23a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bd19b050078bb03dcda2fa61b34170d6132ee5d7924ae1ed956d6fd04d463e71"
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