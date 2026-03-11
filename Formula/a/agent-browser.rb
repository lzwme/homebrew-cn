class AgentBrowser < Formula
  desc "Browser automation CLI for AI agents"
  homepage "https://agent-browser.dev/"
  url "https://registry.npmjs.org/agent-browser/-/agent-browser-0.17.1.tgz"
  sha256 "57b63d88f3bb76211632188a60b4502c1ba764f7d3c8ccee08599c8f52baee72"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7bdc95b28e650f94e1a8162cd6948801f23e87281e74a012985ae75874417e19"
    sha256 cellar: :any,                 arm64_sequoia: "96ce55ac8379f305d5a451146c306c8170c8c2d716d2752a4e09cbe6ec83a944"
    sha256 cellar: :any,                 arm64_sonoma:  "96ce55ac8379f305d5a451146c306c8170c8c2d716d2752a4e09cbe6ec83a944"
    sha256 cellar: :any,                 sonoma:        "92058e3e02a807816a93c35dc38739f746321d596b287d9161a9e0dccf09a1a6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "40f863af879edf1ae221fa71d97b7112a4e16b4404c8ead72cd1057ffb0bd5ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aa7627eebbae0d3ba3b7f14d9e2531a8e5f1a93d1952b92a71f6ebe68672edda"
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