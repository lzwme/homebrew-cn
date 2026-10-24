class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://github.com/danielmiessler/fabric"
  url "https://ghfast.top/https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.553.tar.gz"
  sha256 "4a861a46bfcf857148887332c70dd1ec60b4eb88cb431ca80c6a850c115552e7"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b94a9ed13b2c4ab2cac34cfb7bf3a1078592d880dc01ca7d2fe3a82a5ea48043"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b94a9ed13b2c4ab2cac34cfb7bf3a1078592d880dc01ca7d2fe3a82a5ea48043"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b94a9ed13b2c4ab2cac34cfb7bf3a1078592d880dc01ca7d2fe3a82a5ea48043"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "e141510435f32d7239324a9b1957bbdae8b16f382b96f4e9b34941d533d7e4f8"
    sha256 cellar: :any,                 x86_64_linux:      "08fabb5c2df4eaa69be172e341346d3fc1e8bd96504befef7e9b847426e4857a"
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