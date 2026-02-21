class AgentBrowser < Formula
  desc "Browser automation CLI for AI agents"
  homepage "https://agent-browser.dev/"
  url "https://registry.npmjs.org/agent-browser/-/agent-browser-0.13.0.tgz"
  sha256 "c57a35aeeb5a5792480ffbf40c3f8cb824c054de5d16fa34bc571c2a40f7083c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7895e1dfe6ad5225098bb7847863e0f5bc4e5052694bb17057e8ab1a219e5483"
    sha256 cellar: :any,                 arm64_sequoia: "ee6eeb872bc34d382807412434f8c8ed13951e7ad9d5c3b9926cb50a32e67d1b"
    sha256 cellar: :any,                 arm64_sonoma:  "ee6eeb872bc34d382807412434f8c8ed13951e7ad9d5c3b9926cb50a32e67d1b"
    sha256 cellar: :any,                 sonoma:        "1d6b5e2c00b57f3cdc228fb2b19030922a905b49f9dfe39771460928afd08e55"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "48b8608278723b8fcfc15a6ea6709b2b9815f3c1926e9493e21210eeadb9d33d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "695608fd0237f6beefa2c32f7635c599055be9ad0c3fa990309bdcf8ac7f7f50"
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