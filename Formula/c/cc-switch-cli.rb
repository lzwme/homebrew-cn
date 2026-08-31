class CcSwitchCli < Formula
  desc "All-in-one assistant tool for Claude Code, Codex, Gemini, OpenCode and OpenClaw"
  homepage "https://github.com/SaladDay/cc-switch-cli"
  url "https://ghfast.top/https://github.com/SaladDay/cc-switch-cli/archive/refs/tags/v5.10.4.tar.gz"
  sha256 "cb10c2742b5552bb4de4cf58663afdf8d79e96e05ea68b5533489a6ba0583dcb"
  license "MIT"
  head "https://github.com/SaladDay/cc-switch-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e8941824fae80b72650f540f17b1a2e68a93a59df6d9245eb4e629bac41ad5b7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b58c7953277f4af0a222ab1e7f3e62c9fd36a829836b28c59eeeec92fd497a31"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c4563cd1b0e09ddbc142bdaf23341dc7b9be3a8b96766bc6df081b7c451203e6"
    sha256 cellar: :any,                 arm64_linux:   "f3870a7f984ff57f2db07f2ad27625be0cd3991c212b91bedfda0ef706f55d27"
    sha256 cellar: :any,                 x86_64_linux:  "cff199d6156b81d83844cb5d67f7863d89c62529b617039e2b291e18d9cff329"
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