class CcSwitchCli < Formula
  desc "All-in-one assistant tool for Claude Code, Codex, Gemini, OpenCode and OpenClaw"
  homepage "https://github.com/SaladDay/cc-switch-cli"
  url "https://ghfast.top/https://github.com/SaladDay/cc-switch-cli/archive/refs/tags/v5.8.6.tar.gz"
  sha256 "196f78656755450e29d19557bd2b7a9d0de76ebb5e9c0e7c0868023152a25cf9"
  license "MIT"
  head "https://github.com/SaladDay/cc-switch-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "521cee4f025074a2fc2ebe0ca9d5210ab245114d540589c55f0b960ee7a5a3d5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "29ffc5c726e52afd38da831c47ae7e25be940f20200d40a1a355ec915b28672b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5d6c3649b8773f98b3b7f1cda50c59a40ef6b2a89690254c419689283eb7d1f6"
    sha256 cellar: :any_skip_relocation, sonoma:        "dbe245956e6d26fb1f085605aa8cc5b233e8bf8328f6d7e0fdebc7811192f015"
    sha256 cellar: :any,                 arm64_linux:   "9328ccda81b90d883ad56a734b3330ce4ddc72421b77909336b6b3630e45c337"
    sha256 cellar: :any,                 x86_64_linux:  "659122eb98efd7dd98d403b93c783c5c4b7dd3dc76cc56a3b770c8f1fdd895f1"
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