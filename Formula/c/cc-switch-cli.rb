class CcSwitchCli < Formula
  desc "All-in-one assistant tool for Claude Code, Codex, Gemini, OpenCode and OpenClaw"
  homepage "https://github.com/SaladDay/cc-switch-cli"
  url "https://ghfast.top/https://github.com/SaladDay/cc-switch-cli/archive/refs/tags/v5.11.0.tar.gz"
  sha256 "995fff656a0e086a0c0ada429894e9044071ed52d7bfa6625c2ae86ac35bded4"
  license "MIT"
  head "https://github.com/SaladDay/cc-switch-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7de8e8f9cc2eb7afb26460ae134271bb1f832434b3841d9e32279e4c1d352fd5"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ebf341ab528015b4f42ef655b100fc8796b7bc1d2cc15b7f53545134f694631f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8363f23b8c46895ac3c4acc66ea0a1a40490c469c987be707939998269246c1d"
    sha256 cellar: :any,                 arm64_linux:       "b86a739e48ddef1b1ffb6da0ea4e8b6705ab53ca4f6c71d6b83691e43b1e2418"
    sha256 cellar: :any,                 x86_64_linux:      "167a7d21d9ca3e1c9e77d5bbcb769feef99af3174991a119d8cfabce96b05fca"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args, "--manifest-path", "src-tauri/Cargo.toml"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "src-tauri")
    generate_completions_from_executable(bin/"cc-switch", "completions")
  end

  test do
    ENV["HOME"] = testpath.to_s
    ENV["XDG_CONFIG_HOME"] = (testpath/".config").to_s
    ENV["CODEX_HOME"] = (testpath/".codex").to_s
    ENV["CC_SWITCH_CONFIG_DIR"] = (testpath/"cc-switch").to_s
    ENV["ANTHROPIC_API_KEY"] = "cc-switch-test-api-key"
    ENV["CC_SWITCH_BREW_TEST"] = "1"

    output = shell_output("#{bin}/cc-switch env check -a claude")
    assert_match "ANTHROPIC_API_KEY", output
    assert_match "cc-switch-test-api-key", output
    assert_match "conflict", output
  end
end