class CcSwitchCli < Formula
  desc "All-in-one assistant tool for Claude Code, Codex, Gemini, OpenCode and OpenClaw"
  homepage "https://github.com/SaladDay/cc-switch-cli"
  url "https://ghfast.top/https://github.com/SaladDay/cc-switch-cli/archive/refs/tags/v5.10.0.tar.gz"
  sha256 "862a3fc1bc0908865ce6d616781a385d39eb3677ad5058a13f9fe8b89d8f1354"
  license "MIT"
  head "https://github.com/SaladDay/cc-switch-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8428648ace455a77af22cb721defdfe3e74ca0d0a9995695db0de56fb10b93b7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5b5d4a0d68c4b21209b480191c158f372025aa6bfaf62afeae622b82f1aaa2d8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7df669a0e9fc32cc247752c0f05c2ebd7255637f2f2e4585ae3abbd464043cc3"
    sha256 cellar: :any_skip_relocation, sonoma:        "804a0e51fa324dcbd0d351c7205233bc57af2eb87cd015fc962fe5e226948f90"
    sha256 cellar: :any,                 arm64_linux:   "b91c84c38ca4cb5ef82312dc7e027aa241d615c7601ff5390701818c7e34bf7f"
    sha256 cellar: :any,                 x86_64_linux:  "10cedc981ca1921078cb3ccbb0d71e943b045854c11c2fe172776ef5a82ecf8c"
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