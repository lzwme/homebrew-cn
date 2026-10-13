class CcSwitchCli < Formula
  desc "All-in-one assistant tool for Claude Code, Codex, Gemini, OpenCode and OpenClaw"
  homepage "https://github.com/SaladDay/cc-switch-cli"
  url "https://ghfast.top/https://github.com/SaladDay/cc-switch-cli/archive/refs/tags/v5.11.1.tar.gz"
  sha256 "8d9b6bc7f09f4e2177e3255a529b2616a76a514b5fcb4a90894cc86f84e8dc62"
  license "MIT"
  head "https://github.com/SaladDay/cc-switch-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6a7ac1896f4aa7e7997b23bfe18f08d5ceb5c9e82072a1fbe5bb10c3da9f919c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "3063e6053a2d711d55fd5b7e16ef1496df8dfbf0b36e8b55abee3d57e8b7edfd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "21b9bb03f8ec49b9fff31f57a0f3e0bfbbbe24856fe6d07f1565357c40fe1999"
    sha256 cellar: :any,                 arm64_linux:       "88e34150e98d51aa6ef64d0bce7463b2ac6ce061db1c896e1637d149ae8142ec"
    sha256 cellar: :any,                 x86_64_linux:      "daf16046e76d4984e744c9db141eb8bd1cff57184d41a087ecd9b624f8dafdab"
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