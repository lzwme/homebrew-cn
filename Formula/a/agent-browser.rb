class AgentBrowser < Formula
  desc "Browser automation CLI for AI agents"
  homepage "https://agent-browser.dev/"
  url "https://ghfast.top/https://github.com/vercel-labs/agent-browser/archive/refs/tags/v0.27.3.tar.gz"
  sha256 "430c4dbb77899e3ba43492441c1fc593cdf954a8aee970bc91235fa73e98090c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1af6892bee6f7549ef13761f3cff03def7975cde07270642573fca7201ea8683"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "734968abbfe698750b2e229c93c2cd876bc613b0ffd2802c49cdff3c5e4e1731"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "954591d3a77205bdc1ac29d0038ff9994c01d4ecbd5c54ef40d41cfa0ab0ef21"
    sha256 cellar: :any_skip_relocation, sonoma:        "606255a6aaa13f09c7e996598170e701163bb78b15080759a91617387d9b6d82"
    sha256 cellar: :any,                 arm64_linux:   "b25b5787083e39feaf7d05a992c39b603bbcccaa38cf836ba85d4ac5127a6bb8"
    sha256 cellar: :any,                 x86_64_linux:  "aef3f5ddaf968a4e76fe88010c01cdd63667eee6fcc75d80b33e90eb899c760f"
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