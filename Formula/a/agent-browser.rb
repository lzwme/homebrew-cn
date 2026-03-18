class AgentBrowser < Formula
  desc "Browser automation CLI for AI agents"
  homepage "https://agent-browser.dev/"
  url "https://registry.npmjs.org/agent-browser/-/agent-browser-0.21.0.tgz"
  sha256 "a4bf26cd9c3708abcdbe72fe414f9fd30eedf287ae2a98fa0f1d3a8b4b59cfda"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c53471281dc2a8e61fde5555822b885ea9e2c12cec0b64ab67bc0ff4ef721aaf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c53471281dc2a8e61fde5555822b885ea9e2c12cec0b64ab67bc0ff4ef721aaf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c53471281dc2a8e61fde5555822b885ea9e2c12cec0b64ab67bc0ff4ef721aaf"
    sha256 cellar: :any_skip_relocation, sonoma:        "bb0d5c42cfe5d1310330b3643ef1380504a793ab2f756ed863d2ca1622dfacf1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "084ea9c7cff26862f184011f2fa4f6c1662b1e6331c80b826ecd889a00b5c5b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a7410fff04cb099b1f46a270b3eca3ffae01c2e3337a5d42784edebb283d7ffb"
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