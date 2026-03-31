class AgentBrowser < Formula
  desc "Browser automation CLI for AI agents"
  homepage "https://agent-browser.dev/"
  url "https://registry.npmjs.org/agent-browser/-/agent-browser-0.23.1.tgz"
  sha256 "a691a00439b47d21418c68eda793bee3af6b1161a4f7faf52e7e73b9eccb6beb"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2db27f15c289b37a661641ea895ea47f2b23a70b69bd1eb2aba4fcb1b6b07679"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2db27f15c289b37a661641ea895ea47f2b23a70b69bd1eb2aba4fcb1b6b07679"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2db27f15c289b37a661641ea895ea47f2b23a70b69bd1eb2aba4fcb1b6b07679"
    sha256 cellar: :any_skip_relocation, sonoma:        "2173fcdfd6f13758a46561b6874f771d73f0734cea3a735bae028dd822a44f76"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "860688ba1cf75d2e1ec4d18fdd4a874665f69186a4a2f4611ffa350aa848b1ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6207e9acd552df4654192377a5549315edfff68a0e7ef84fb66b84d1fbcd558a"
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