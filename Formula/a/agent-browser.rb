class AgentBrowser < Formula
  desc "Browser automation CLI for AI agents"
  homepage "https://agent-browser.dev/"
  url "https://registry.npmjs.org/agent-browser/-/agent-browser-0.17.0.tgz"
  sha256 "ef4a25d1513c2a38b3e8c7323bab1fe4ea601944476716c1a307ae259417040b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "22eb05d572c3be5a7924e65c488e484cd69756b43545437e12946b7b3683472d"
    sha256 cellar: :any,                 arm64_sequoia: "e452da9a47babccfd84bbdbcf15e49a284a871a6ba9932cecb5da9756d41f047"
    sha256 cellar: :any,                 arm64_sonoma:  "e452da9a47babccfd84bbdbcf15e49a284a871a6ba9932cecb5da9756d41f047"
    sha256 cellar: :any,                 sonoma:        "77038703c77c2d28835d1ab234461831bbda6e663f2a472883aa97501ad2991a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cce74877ce5f442f49c2f4f65aca47bc94147a06bbe03a18f582eb3b08783ac6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4e435e99cf9f8a7c21c8fe234d32317021b32ba7d01e4bc89571913f76134c40"
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