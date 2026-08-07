class CcSwitchCli < Formula
  desc "All-in-one assistant tool for Claude Code, Codex, Gemini, OpenCode and OpenClaw"
  homepage "https://github.com/SaladDay/cc-switch-cli"
  url "https://ghfast.top/https://github.com/SaladDay/cc-switch-cli/archive/refs/tags/v5.10.1.tar.gz"
  sha256 "8e03202bb45255a52f74132bd7310f7db44bdb983fcb7737642d40af587776b2"
  license "MIT"
  head "https://github.com/SaladDay/cc-switch-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5453e4a5640a072a6236ad4a4c6b6a3941214509f81b7b9455b40aa46531d8e0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "80a7568f0ef1b8001c1f2aff3746220dad6a23d8188ad078eb3926e69c005810"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0a7bbe3a62fe499898ca614db86e5a84efa938628a4851d76a4decf3e12369ef"
    sha256 cellar: :any_skip_relocation, sonoma:        "23d626bda87c74b811016954c2284d7e299d2fa8d42701c6fc023f6c071b671d"
    sha256 cellar: :any,                 arm64_linux:   "3febdddf872bf8cb1b24a8bf7f3fcb983ddbca19bcbcb4c72cda4f9aebe54fbd"
    sha256 cellar: :any,                 x86_64_linux:  "a392e9b5cea61ed01128287bf8af6e053ee22784c0a367cf158763e045f5ade1"
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