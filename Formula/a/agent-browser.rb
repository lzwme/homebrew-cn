class AgentBrowser < Formula
  desc "Browser automation CLI for AI agents"
  homepage "https://agent-browser.dev/"
  url "https://registry.npmjs.org/agent-browser/-/agent-browser-0.20.4.tgz"
  sha256 "cf2d4563016d2d184ee27fdb66a1a5023545c988589e9344b15829e76adad2bc"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "95822d5acc1cdb816c2dde8ddcfbdb4934a19e76bf95236118d2d2096b49348b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "95822d5acc1cdb816c2dde8ddcfbdb4934a19e76bf95236118d2d2096b49348b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "95822d5acc1cdb816c2dde8ddcfbdb4934a19e76bf95236118d2d2096b49348b"
    sha256 cellar: :any_skip_relocation, sonoma:        "e013be2eeeac83f1c1d8c86836a1f9382633d714140364b1adb313bb8040c423"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1b8c3a58c9ce656d2a09c5ee7ae47427b2a929891c5eb7c46582342615cfa0bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b7aabd20b88e0dc6aacaddbd7f8ebcf95a8b78c248139f82343f67dcacef07f2"
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