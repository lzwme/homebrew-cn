class AgentBrowser < Formula
  desc "Browser automation CLI for AI agents"
  homepage "https://agent-browser.dev/"
  url "https://registry.npmjs.org/agent-browser/-/agent-browser-0.18.0.tgz"
  sha256 "8a0bc576a5ac7f5f39697b025f18ae755589a6b58cabb3e798bc4a685ff92b39"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f7a432fbf25a5d0909816aa67ac0d7a029fce646d97544779875c69859051370"
    sha256 cellar: :any,                 arm64_sequoia: "ebf08203b6cfc7f1aea617fb7dc967348fef809cd7d25a44523c7c42d1eef6f0"
    sha256 cellar: :any,                 arm64_sonoma:  "ebf08203b6cfc7f1aea617fb7dc967348fef809cd7d25a44523c7c42d1eef6f0"
    sha256 cellar: :any,                 sonoma:        "69c84fdc5c2867bae5512d80c91b6acb3d0195b0b52bc568b4e824948a06d802"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7315aecc332fde5766d1895570785bc906518c7a540752da652b1ec7dc419d01"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a4cb5bf1a2dab9ad14f5cbef40e4247ba2264063414056db69dad4038ec21c58"
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