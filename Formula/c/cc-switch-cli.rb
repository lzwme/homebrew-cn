class CcSwitchCli < Formula
  desc "All-in-one assistant tool for Claude Code, Codex, Gemini, OpenCode and OpenClaw"
  homepage "https://github.com/SaladDay/cc-switch-cli"
  url "https://ghfast.top/https://github.com/SaladDay/cc-switch-cli/archive/refs/tags/v5.8.3.tar.gz"
  sha256 "d4648c09ff92ad2f2d3a36df59efe8b3e57e01b9d5e2d699a85e612958751aac"
  license "MIT"
  head "https://github.com/SaladDay/cc-switch-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "94bfcbbe5a05eeaf1d88edf4ca4ec07791b034fba1ea58cd58a28829ca90e40b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6d5e358ed47710c3f252bdd0ba6a0f56df34f68d692b4381eaa560418acbf87d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "97c7ad6cd4580ba3ddc54ca7abf045294f714302985e91f1a2e028024172d0e9"
    sha256 cellar: :any_skip_relocation, sonoma:        "60f266c327ea47e9d0c6189622ae777ba94ee84293c38880773a0b72e1ee6aa6"
    sha256 cellar: :any,                 arm64_linux:   "fe19f55dbc940afd6f7b7373b782f51a33e765b99218b11866355c55d5b5084e"
    sha256 cellar: :any,                 x86_64_linux:  "4decc75e1e483cd73a7c8343d2edf60e5eac2873ad0dfdf88846e9e1b35cc530"
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