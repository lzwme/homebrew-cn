class CcSwitchCli < Formula
  desc "All-in-one assistant tool for Claude Code, Codex, Gemini, OpenCode and OpenClaw"
  homepage "https://github.com/SaladDay/cc-switch-cli"
  url "https://ghfast.top/https://github.com/SaladDay/cc-switch-cli/archive/refs/tags/v5.8.0.tar.gz"
  sha256 "b64660a4131d10efa14b9f2122e1c113d2ce2240e7ae68d7f62dc7d4780d2909"
  license "MIT"
  head "https://github.com/SaladDay/cc-switch-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7618ba18c9ab9af04eb463df84c3cf60bb35103a82cf0ced8f84340566d8b768"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2ceb4bb4bbe1f640e393f1510566ba460005b3ec8806caab69c0bffa13c08d7f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8865b7ced332dce66664ef5185ee1483044221bb20fadb4f5248ba8c68fd9fe1"
    sha256 cellar: :any_skip_relocation, sonoma:        "857a422e0f18408de39cd312faac4d3f8a372c03fd6fa4f057a9fc1e9df0f636"
    sha256 cellar: :any,                 arm64_linux:   "8ee99983508d74bc97b34ca5871ce8061a67edd70c96a717c5da1d8cba84e504"
    sha256 cellar: :any,                 x86_64_linux:  "b05b0e0fc54fefa1eb7b84125c8827e64a079f419a03866b6f52a3c972723c4b"
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