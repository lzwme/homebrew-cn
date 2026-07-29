class AgentBrowser < Formula
  desc "Browser automation CLI for AI agents"
  homepage "https://agent-browser.dev/"
  url "https://ghfast.top/https://github.com/vercel-labs/agent-browser/archive/refs/tags/v0.33.1.tar.gz"
  sha256 "313e7706485c246b818a2138dabc6f8784f91bfa25cae7db445e6ca14c730022"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7818c2bf9d75d426b20328084dae3dd148eb87e7ffca6ab44cf04fba15260d18"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fa0aabe0fd411a5e2584ef086b6c873a7369dbf3e961d636adc13a3dea21ab22"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b3ecee95abc3329a955bbf0a82a4b8e7373f01bd6ab2f9b646cead7a2a9438d0"
    sha256 cellar: :any_skip_relocation, sonoma:        "9840fba3f778cc826b306334f52841d096307cde406af7f9e4e4152e466ba52a"
    sha256 cellar: :any,                 arm64_linux:   "de6b022b0a04340c214d5936c5219eff6c8a339f5909efefbb8533dfc1c3bb31"
    sha256 cellar: :any,                 x86_64_linux:  "300823ea977931a8cfbf071d8b5bc3708276a633cdc2a657c6d42367c4180e7c"
  end

  depends_on "rust" => :build
  depends_on "node"

  deny_network_access! [:postinstall, :test]

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