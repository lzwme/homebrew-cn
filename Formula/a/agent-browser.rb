class AgentBrowser < Formula
  desc "Browser automation CLI for AI agents"
  homepage "https://agent-browser.dev/"
  url "https://registry.npmjs.org/agent-browser/-/agent-browser-0.23.4.tgz"
  sha256 "b8b8bb2ac7a6db5d6410541a6b4d322036c633c20df06c98fc7cc4eafb638b5f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "34cdd12ab8711fdcc9a480a40e310965145df08870b6319b2e3b3930e9a03b8b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "34cdd12ab8711fdcc9a480a40e310965145df08870b6319b2e3b3930e9a03b8b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "34cdd12ab8711fdcc9a480a40e310965145df08870b6319b2e3b3930e9a03b8b"
    sha256 cellar: :any_skip_relocation, sonoma:        "4522603f03b037403032349d6f72942d0e73ff030b3f672dccce772b5b3b3655"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ca4ec032f665b2cfe740fbc3585d02835491e8358edd669fdf25ec1a396b97dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3cc6a70e357e191121c5f92fb868848221d3131305852f1761edd14d7309b14a"
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