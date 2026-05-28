class AgentBrowser < Formula
  desc "Browser automation CLI for AI agents"
  homepage "https://agent-browser.dev/"
  url "https://ghfast.top/https://github.com/vercel-labs/agent-browser/archive/refs/tags/v0.27.0.tar.gz"
  sha256 "d4428ba7af210e5816aa72b8ed83a84396755ba94770da7118f611a30fd9286f"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4df8b5c62a343265e9548507f911ef5fb5f99a229cc107994b74562a9f5e3753"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c45be8818c717bf54c8ee834508f9895856db739ea9177f358bb2e3f5817e7f4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "93f2172ea6a94bbf78837c91bc6c4a578a37b20948cbe4e135393c02234276c3"
    sha256 cellar: :any_skip_relocation, sonoma:        "1317d6cdd819d8664fa21cde2badbf49a7a5a691bfc919aa3dab32873efcf933"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "24ad798a274a97e6a6dddd068514d4cc5429e45c8c705cfadb839846ef226e19"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4ecf11d1e4f5ac29f23cbf6200acce57e2b8780e3ebc0ec5ccb0f9fbf9d639f8"
  end

  depends_on "rust" => :build
  depends_on "node"

  def install
    system "npm", "run", "build:native"
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
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