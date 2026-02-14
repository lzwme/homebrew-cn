class AgentBrowser < Formula
  desc "Browser automation CLI for AI agents"
  homepage "https://agent-browser.dev/"
  url "https://registry.npmjs.org/agent-browser/-/agent-browser-0.10.0.tgz"
  sha256 "f454d01dcbb55dd48607ffdc2d004e9be2e95cfa378c9c7a1d5d6f5284006642"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "34c4dda5817f7e09c31ec497dd84a45cf48c3e99f6bd2c0a669615bab4508785"
    sha256 cellar: :any,                 arm64_sequoia: "bfd037c2c0584e5a8d37e031eb32fb543760e871aaf0eda5e0a8ff96713e7768"
    sha256 cellar: :any,                 arm64_sonoma:  "bfd037c2c0584e5a8d37e031eb32fb543760e871aaf0eda5e0a8ff96713e7768"
    sha256 cellar: :any,                 sonoma:        "3e4fad841bc16b382360270d3559f3eec5ef54fd2e54a7da6244dc8fe217fae4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b287f71313e8ec8c6732d13bf3730398f7b766be42cad855af1fc737936fa52c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8a85db48c185e3b15f405c9717f229405e03ef128c220d8dd9d009351cba6699"
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