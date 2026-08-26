class CcSwitchCli < Formula
  desc "All-in-one assistant tool for Claude Code, Codex, Gemini, OpenCode and OpenClaw"
  homepage "https://github.com/SaladDay/cc-switch-cli"
  url "https://ghfast.top/https://github.com/SaladDay/cc-switch-cli/archive/refs/tags/v5.10.3.tar.gz"
  sha256 "ad1e9d0295954325d7b348cdcdd9237e494aa4dd042b8f5039ec6ffa5b652147"
  license "MIT"
  head "https://github.com/SaladDay/cc-switch-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d877bf4be0f457bce0646180532a1fa8144374dbb54660722ad5abef9fc8e79c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e34aa110c297cf46844137beba2eae8c868293d65427ebc188164d698231c5c4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e9201e743053ff4f2aec8582ae37640cfcf5b3cd1011c7618ffb9482a687ca4b"
    sha256 cellar: :any_skip_relocation, sonoma:        "51146a3d62885938796a73886a8ba0da7f130e90d856cefd22fd5423ff00210c"
    sha256 cellar: :any,                 arm64_linux:   "e3d358533442e89dbad6a71851ead38a3e14b5ad862dbfa656d9c0764a21f3a7"
    sha256 cellar: :any,                 x86_64_linux:  "3ab1d40bd1cfc55e58559d3ef91b5040189623820f31ac49a42f8a913b586221"
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