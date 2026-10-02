class AgentBrowser < Formula
  desc "Browser automation CLI for AI agents"
  homepage "https://agent-browser.dev/"
  url "https://ghfast.top/https://github.com/vercel-labs/agent-browser/archive/refs/tags/v0.38.2.tar.gz"
  sha256 "a3a347ed468fcc2e593e3ae95a6a08df1efeb94d57b33fbc48627b889ea0ec48"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "4be262d45f2c6ab3f296a974b7be7dae1cf230e43e52eed68aefcba659472cb7"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "cbf2d7a7dcd0d0372a2c9d109954ee9e338d5e155590d90cfb64492d34f96e58"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "31f76cc57c07a639b01b5c477b845fd0ccacf799c71aee7362ab9f12f66bfd7a"
    sha256 cellar: :any,                 arm64_linux:       "24d62711c9fe01f716509aa5ebf3096ca488839a66f1a0f26225d1fbdc9dd374"
    sha256 cellar: :any,                 x86_64_linux:      "97afff1f951d49d9fc10bd169011ad22ca9f8b87a095e9284e2a027021a5c486"
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