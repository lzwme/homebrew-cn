class CcSwitchCli < Formula
  desc "All-in-one assistant tool for Claude Code, Codex, Gemini, OpenCode and OpenClaw"
  homepage "https://github.com/SaladDay/cc-switch-cli"
  url "https://ghfast.top/https://github.com/SaladDay/cc-switch-cli/archive/refs/tags/v5.8.2.tar.gz"
  sha256 "8bc95618ee500eb1df1135632c5fdca64a6a25b5113a35537700ffeb6f88e97c"
  license "MIT"
  head "https://github.com/SaladDay/cc-switch-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d555b17fc571a552d3971ca0deb4b9f6aeb017666461df55baa05e90eeff42a2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d56c1e25ce5d3e73374af135ce4615b202c27e3b92106a0c7b075af4c0a18055"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c23faf519b2046d39a2a805c2b76239b4bd498663a6c3aba5c2c12ba91855583"
    sha256 cellar: :any_skip_relocation, sonoma:        "71f37aec0f3b69a71adbd9170883bf4e76297b496654423596a8d50cdadd5bc9"
    sha256 cellar: :any,                 arm64_linux:   "7420e9d1b298e0f7f69237c085dbeec5d8447020aee7c0ecf61270fac89df076"
    sha256 cellar: :any,                 x86_64_linux:  "7fec688a0f3db4b2dde6846839a53c5d76778c0ebeee9931856a560dbe6f3354"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "src-tauri")
    generate_completions_from_executable(bin/"cc-switch", "completions", shells: [:bash, :zsh, :fish])
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