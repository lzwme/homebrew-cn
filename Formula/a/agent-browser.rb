class AgentBrowser < Formula
  desc "Browser automation CLI for AI agents"
  homepage "https://agent-browser.dev/"
  url "https://registry.npmjs.org/agent-browser/-/agent-browser-0.25.1.tgz"
  sha256 "f410dac1312a03d32a647d41fffea2ca4d0365a5a4f667bd86d075ab25f62ef1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "557259dfd6332fe0d0b504180c81e454cac66866d24a9e61a4abaef6ff6e72a6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "557259dfd6332fe0d0b504180c81e454cac66866d24a9e61a4abaef6ff6e72a6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "557259dfd6332fe0d0b504180c81e454cac66866d24a9e61a4abaef6ff6e72a6"
    sha256 cellar: :any_skip_relocation, sonoma:        "dde4cc060a9570526b82d94d267bf7ee6f475c2d3b7f52a3ec701bfd38662406"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e0c7f2296c379f7c89bc76fa597303d9c0f63a9837c0f232bb76786a38489e56"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a428ceaa6e2fdd58b2894e564318ea21038e76057685ff5f0dc57aa2a5225da0"
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