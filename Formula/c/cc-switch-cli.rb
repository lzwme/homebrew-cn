class CcSwitchCli < Formula
  desc "All-in-one assistant tool for Claude Code, Codex, Gemini, OpenCode and OpenClaw"
  homepage "https://github.com/SaladDay/cc-switch-cli"
  url "https://ghfast.top/https://github.com/SaladDay/cc-switch-cli/archive/refs/tags/v5.9.1.tar.gz"
  sha256 "c3d878a20eedfbcea2f26207decc82c22b85bb404539603223d3f2002f5aa45f"
  license "MIT"
  head "https://github.com/SaladDay/cc-switch-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "969286a6c15ae237987fa5d2ef5ded675470d113a03726a2c17356950e9d9709"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8ac00c30ae5474bfd4d6286f432765ff3fd5befa62eac4fa419b22024cef016c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5ad8bd12b2796380fe5c145d6e5ff7773d9ea7868dd924b0ec311d5d5750fcf6"
    sha256 cellar: :any_skip_relocation, sonoma:        "2cc45f1a0fc83b07cd31c845f50f79153847657a91204d17a4ed4c6b4747c55c"
    sha256 cellar: :any,                 arm64_linux:   "40b845e0da6a9270d0709efff0bf6f6d684c167b9dc63ee66013770fe8484f8f"
    sha256 cellar: :any,                 x86_64_linux:  "1903a8a9879d58a9b653f030821e3a2095df33798a85a56c98fcdf47d468cf46"
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