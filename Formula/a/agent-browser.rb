class AgentBrowser < Formula
  desc "Browser automation CLI for AI agents"
  homepage "https://agent-browser.dev/"
  url "https://registry.npmjs.org/agent-browser/-/agent-browser-0.16.0.tgz"
  sha256 "bc85c1ce709ac25cbf07bf2a42b05ab0c39ff138075ec50e8d5510e00d52bb10"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4241aecbba88bd71f37b7cd189263bdb0ed203d4dce255a66e1515582b6d3cf8"
    sha256 cellar: :any,                 arm64_sequoia: "91c437afcec04a3add06ab419657d85a1734c6a1142c3462737592cfece6b885"
    sha256 cellar: :any,                 arm64_sonoma:  "91c437afcec04a3add06ab419657d85a1734c6a1142c3462737592cfece6b885"
    sha256 cellar: :any,                 sonoma:        "dcaa83282dfec280b5ec25cec1ae678ac348437ad2286ce96aeed2b572d0410c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1c4af93ca656f13d883167c4d8b5421b70e4e701d4c7d60ce3b6eca916c8a324"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fed9301c310e4de98e53afe519fe9e8f168dc8f0b1e05801166b01a597e82d5c"
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