class AgentBrowser < Formula
  desc "Browser automation CLI for AI agents"
  homepage "https://agent-browser.dev/"
  url "https://registry.npmjs.org/agent-browser/-/agent-browser-0.9.1.tgz"
  sha256 "53356c6ecb7cd5d253b828def43c1727d2f60a6f022c81b93ba29646fa20bc7b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ba05fe0db6538ad35154d90ba0972198947daf934dcacfc312923bc3d9be6963"
    sha256 cellar: :any,                 arm64_sequoia: "cd2407d4b097b060c856e5c42ab1ea6388b70ee0b98cd9f7915a66f82ee96a39"
    sha256 cellar: :any,                 arm64_sonoma:  "cd2407d4b097b060c856e5c42ab1ea6388b70ee0b98cd9f7915a66f82ee96a39"
    sha256 cellar: :any,                 sonoma:        "fee69e52a73a19262c31bcb4f34228d3145d1f211896ded5d350a8da3c00e88b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "77597705f924c13b9362fed12d239793145502a9779aaf4bc60163a1a2573b54"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e633e23020f42da9816661ebe50920c481b77ddd26045cbd088184f5754aa8a0"
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