class CcSwitchCli < Formula
  desc "All-in-one assistant tool for Claude Code, Codex, Gemini, OpenCode and OpenClaw"
  homepage "https://github.com/SaladDay/cc-switch-cli"
  url "https://ghfast.top/https://github.com/SaladDay/cc-switch-cli/archive/refs/tags/v5.8.7.tar.gz"
  sha256 "1c747f7981edb6edc342eda6c030833b7a953193fc2adde3ce02e07c45bcdb03"
  license "MIT"
  head "https://github.com/SaladDay/cc-switch-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "604e3341bd5cfb380be22b27ca1c787c754a550cba2545acdb17e9a5bde80016"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2d83deccfbcc6f6accc1f93b8f6043c7a7ad3c1be796a69fd9e00e04b12c4ecf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "31a158afcff89fd21685ff73c976a3c1585a75eee086d4019d42fa24fef695a5"
    sha256 cellar: :any_skip_relocation, sonoma:        "abea2191e88bd75db03ec99b40858fcc3169dd959cea87e637be73755e71e193"
    sha256 cellar: :any,                 arm64_linux:   "77f455dd16ad2e730b601c6863901ac49103c1763949d28aa92882e2e1a497f6"
    sha256 cellar: :any,                 x86_64_linux:  "700eae7b5d809f7dc987043964af243163ca907c074e10035b178245edfa5dfd"
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