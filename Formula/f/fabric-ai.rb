class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://github.com/danielmiessler/fabric"
  url "https://ghfast.top/https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.344.tar.gz"
  sha256 "82e751eae922e4acf235c7602901b9b1be4b45702587015d71b47f764e4ed4a6"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1a9f5fb6f4c07092934bfced173c55699ceb2cfef1ca914d270311ae0a1b434a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1a9f5fb6f4c07092934bfced173c55699ceb2cfef1ca914d270311ae0a1b434a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1a9f5fb6f4c07092934bfced173c55699ceb2cfef1ca914d270311ae0a1b434a"
    sha256 cellar: :any_skip_relocation, sonoma:        "4f3f7b002f184990d6998bf4c41c5ad189b5428c377370b0ca5cbcb747312b68"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "389d5f7a9b69960d50ca0eddf3eff4cc7dea4c3687d1b55f78941fec53ea7eb5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7496526999c738b5840edf43b6a1d50d3f2d50bd11c35bc6dcda49388ca0790b"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/fabric"
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