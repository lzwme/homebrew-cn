class CcSwitchCli < Formula
  desc "All-in-one assistant tool for Claude Code, Codex, Gemini, OpenCode and OpenClaw"
  homepage "https://github.com/SaladDay/cc-switch-cli"
  url "https://ghfast.top/https://github.com/SaladDay/cc-switch-cli/archive/refs/tags/v5.8.4.tar.gz"
  sha256 "d1c517cec98bbde45254aa7ebddc46bd80eb1cc628db5cda7983ae592f5e60f6"
  license "MIT"
  head "https://github.com/SaladDay/cc-switch-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f3bc97831c16636f650a99be392fd6b6889e5d6691253ff7e300277d7c3bc914"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dc27132def65b65400457ac794ca07b96a4c2db39054479c2de877a2f83708b2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "23a4b32e747fedbcabaf4127ad59b5e0b9fcbe1410559b5e96610b62b6ccf633"
    sha256 cellar: :any_skip_relocation, sonoma:        "02d096fb9e832126423148fdaf89c1fcfe2e1236f2b58a06b805b72c77515c7b"
    sha256 cellar: :any,                 arm64_linux:   "e73b9ad1df89844487736d16243e306b3afbe0d2ad48fcb88797af232ccb5075"
    sha256 cellar: :any,                 x86_64_linux:  "836002e99d963f0e2ca35c5ce19302bb45607b1a77b8921fb3c9100628f62fe6"
  end

  depends_on "rust" => :build

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