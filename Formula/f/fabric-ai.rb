class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://github.com/danielmiessler/fabric"
  url "https://ghfast.top/https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.505.tar.gz"
  sha256 "58e8b22d4a5c869149d5e1270ab1b4f8537055de94d180774ff595f29edd3dde"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "5449204110651a8b1cc91fe72138cb8fbd2e2cf442b9cc3e4574790d66e3b71f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "5449204110651a8b1cc91fe72138cb8fbd2e2cf442b9cc3e4574790d66e3b71f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5449204110651a8b1cc91fe72138cb8fbd2e2cf442b9cc3e4574790d66e3b71f"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "bd2165f8f267624b4aa814325c6efae653095c01b113a8ac11acce699213e3a1"
    sha256 cellar: :any,                 x86_64_linux:      "f73cc3e9f858f713db53599945915688132eed7587a28a55f6702c5a840ff3fd"
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