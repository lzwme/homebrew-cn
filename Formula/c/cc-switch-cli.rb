class CcSwitchCli < Formula
  desc "All-in-one assistant tool for Claude Code, Codex, Gemini, OpenCode and OpenClaw"
  homepage "https://github.com/SaladDay/cc-switch-cli"
  url "https://ghfast.top/https://github.com/SaladDay/cc-switch-cli/archive/refs/tags/v5.9.3.tar.gz"
  sha256 "b805f0ed6fead63de42cf99e6e9c4cb5da4938023dd2815591159d81c4845091"
  license "MIT"
  head "https://github.com/SaladDay/cc-switch-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6bc043531db16cd84363b14071e99130b523fabb4698c1a409ce38cc4e7201b5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "204f54d82c83438bc2105a4a4803a04b44351b65152b6dda36daed08c9c7c2ba"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "72aa92bfdc4e3e769334fd96419d2d66af95b42af402b0a7c6f451ba6eb473af"
    sha256 cellar: :any_skip_relocation, sonoma:        "e5cb4a0ddcc9347c976ae6b1f8fdfab4e05c93f9c40535e50c355d4e9643059e"
    sha256 cellar: :any,                 arm64_linux:   "069a4bf364b69377b9d43fd9a6cd74c982f73a5627d7c8a3232b71e384598417"
    sha256 cellar: :any,                 x86_64_linux:  "c78a19614439349ef1abd6585eefeabb8a82e0e0f244b8d472b72a1b7ad1c38b"
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