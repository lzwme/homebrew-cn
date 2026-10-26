class AgentBrowser < Formula
  desc "Browser automation CLI for AI agents"
  homepage "https://agent-browser.dev/"
  url "https://ghfast.top/https://github.com/vercel-labs/agent-browser/archive/refs/tags/v0.39.3.tar.gz"
  sha256 "eb132640189e6171f994ba79c3070b6fdd6523fe24c04a01209dafbd167e11c6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1c5631044cbd8be7ee4103b0893bfd74dcd9271c4220308cce686f6c2485bb2e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a95b89b0bf4e1c208c7a89240023d96dbfbb3fdc113ddfebe53d25007d77d51c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8e6775e45c14cc7a047444664ff221a8f2c49a590f778e3e6c16cbe4cd39e858"
    sha256 cellar: :any,                 arm64_linux:       "74a56f5349277127852e07365cab597939649b3b0fa75d3892ab953ae3776cdc"
    sha256 cellar: :any,                 x86_64_linux:      "bb7a89beb3d2ea527f04d458320bf865e10286e19415fe9fcb2256203eb177d9"
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