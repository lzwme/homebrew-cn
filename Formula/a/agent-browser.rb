class AgentBrowser < Formula
  desc "Browser automation CLI for AI agents"
  homepage "https://agent-browser.dev/"
  url "https://registry.npmjs.org/agent-browser/-/agent-browser-0.20.13.tgz"
  sha256 "afbeeb5e68887be1da0eb3ab98dff163c3bd8ce2aec9783a82991c42dfd3303f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c3d1504fb7cf4352edad1c9be9d6f35f04e4498930be75a3a7f1f83dc1dfe7d6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c3d1504fb7cf4352edad1c9be9d6f35f04e4498930be75a3a7f1f83dc1dfe7d6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c3d1504fb7cf4352edad1c9be9d6f35f04e4498930be75a3a7f1f83dc1dfe7d6"
    sha256 cellar: :any_skip_relocation, sonoma:        "6673b7ea57099937d8fb28b53e9e55788c12a1259548e834317eb4fd8f7a159f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e5b67ca96a46bc56b0bbc4a42c71b1c6374b471afd03ccc66daa58d1258ed13e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6b55b6953c00b05b29ea78819ff04a91587a3d2574d79286902d002d9fd909d1"
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