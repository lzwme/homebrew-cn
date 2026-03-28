class AgentBrowser < Formula
  desc "Browser automation CLI for AI agents"
  homepage "https://agent-browser.dev/"
  url "https://registry.npmjs.org/agent-browser/-/agent-browser-0.23.0.tgz"
  sha256 "9be58b1aa1a3d361b2034be8529a9f4e0f5e89ef186f9ec1e4944fba463337db"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ff4b8ea3f04dd901f1e32f11cbf5ecebe72324ce962fe3dccf742712f3e21c5b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ff4b8ea3f04dd901f1e32f11cbf5ecebe72324ce962fe3dccf742712f3e21c5b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ff4b8ea3f04dd901f1e32f11cbf5ecebe72324ce962fe3dccf742712f3e21c5b"
    sha256 cellar: :any_skip_relocation, sonoma:        "4f03a469c449072b5f812d7c827b92911bb00b01d107d0ae2d726e57ca9efa66"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9a7ae086c1158c4a2ce1fec38a70edb079367b0d7270c4aa777d412d20b83f50"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e6bacbead0a09a8103725464f80141227cf87f47b791826d179ade1ea3354fd3"
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