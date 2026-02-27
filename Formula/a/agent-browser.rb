class AgentBrowser < Formula
  desc "Browser automation CLI for AI agents"
  homepage "https://agent-browser.dev/"
  url "https://registry.npmjs.org/agent-browser/-/agent-browser-0.15.1.tgz"
  sha256 "0d8ebda067ed8cdc226885d6541bc8f6607d113da0d0753844f34b55e1a6b0fa"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0047c6d4b0292fca9d64391ac6052187006bf5905a708270c26c96ada76a9d41"
    sha256 cellar: :any,                 arm64_sequoia: "6c11e4b30dfcecebf1ea92b0054944410d2a7d0dc24cd3eafade994724c86910"
    sha256 cellar: :any,                 arm64_sonoma:  "6c11e4b30dfcecebf1ea92b0054944410d2a7d0dc24cd3eafade994724c86910"
    sha256 cellar: :any,                 sonoma:        "16411483e7434990e9456254a8b0b79a0ced2cda0f656246bcff54f99b4bd452"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "604b2d300e17b767e9d8851db0df7a11a1e009bb81885d902308b1e57c07313f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d4d5308f2b01607c9791a25b7c3751685c700bfbf5bcc586792bdc081edeba71"
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