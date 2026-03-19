class AgentBrowser < Formula
  desc "Browser automation CLI for AI agents"
  homepage "https://agent-browser.dev/"
  url "https://registry.npmjs.org/agent-browser/-/agent-browser-0.21.1.tgz"
  sha256 "fade2730f4840da9dbe2b39804264e33502a8e8a68333ec70f29f4b988477d63"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ce3de72eefd713a8d4356786bb33826cbfaa6a5686f4bdd66dd95ce2ae2e625d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ce3de72eefd713a8d4356786bb33826cbfaa6a5686f4bdd66dd95ce2ae2e625d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ce3de72eefd713a8d4356786bb33826cbfaa6a5686f4bdd66dd95ce2ae2e625d"
    sha256 cellar: :any_skip_relocation, sonoma:        "f18f7037aec3874096eee80af0a24f043c3c9386b76b051880c2520a6fd6784a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "db9dbee12ce3fca4a73413148be0a65e40bb028366ac6505baae5c0d5f06500b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6bb27a099e98bef52cb3ac4088d2dc84fb5de7fb806c22c13787ab03f91a311e"
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