class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://github.com/danielmiessler/fabric"
  url "https://ghfast.top/https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.483.tar.gz"
  sha256 "402890991606b0310f7d8713663a5640c9400e69674192e742b51ad1cea13109"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "56ddb09a078280f8d84e5c557c0c27eb6ff9db5ccce3a0ab6b01df4c4809ad7c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "56ddb09a078280f8d84e5c557c0c27eb6ff9db5ccce3a0ab6b01df4c4809ad7c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "56ddb09a078280f8d84e5c557c0c27eb6ff9db5ccce3a0ab6b01df4c4809ad7c"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "b10a39259646bfd458a4d09905a059c74226402c4c2e4ece7f235f7bf4ced5ad"
    sha256 cellar: :any,                 x86_64_linux:      "3b762848bc8b589d6aab66f710061adb65e9f558d9b1e6ec291cb058a5743a16"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args, "./cmd/fabric"
    # Install completions
    bash_completion.install "completions/fabric.bash" => "fabric-ai"
    fish_completion.install "completions/fabric.fish" => "fabric-ai.fish"
    zsh_completion.install "completions/_fabric" => "_fabric-ai"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fabric-ai --version")

    (testpath/".config/fabric/.env").write("t\n")
    output = pipe_output("#{bin}/fabric-ai --dry-run 2>&1", "", 1)
    assert_match "error loading .env file: unexpected character", output
  end
end