class AgentBrowser < Formula
  desc "Browser automation CLI for AI agents"
  homepage "https://agent-browser.dev/"
  url "https://registry.npmjs.org/agent-browser/-/agent-browser-0.21.2.tgz"
  sha256 "f14d756484c12b20007a869f682ae4defa3f4f4b9ec12308ad0a2c382de3cecf"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2a37c25c3ea0738a8955bfda7c69a76a3a64898bd1e6158e365ba797dbfc82ab"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2a37c25c3ea0738a8955bfda7c69a76a3a64898bd1e6158e365ba797dbfc82ab"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2a37c25c3ea0738a8955bfda7c69a76a3a64898bd1e6158e365ba797dbfc82ab"
    sha256 cellar: :any_skip_relocation, sonoma:        "b4c0057ef6e8a4fd4a4681dc61c5b5cbf62b2d6c277570c35f958bad3ad8d4ec"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1009156965847f6c67dd857c2e036712dc92633cf2bb7269d2865ea67d15d1b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "11e7c1a0e498b631ff8973eef320bcef1ba5311c92d44aaf1b45c0953b9cfa07"
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