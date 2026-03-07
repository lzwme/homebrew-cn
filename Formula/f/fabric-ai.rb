class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://github.com/danielmiessler/fabric"
  url "https://ghfast.top/https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.432.tar.gz"
  sha256 "f2b8bc152ee917741414fc74e1bb0fa55aea1f90ab1273a6afcb3b4b946066ee"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4e8163b599bcd4f0c9277a8eedf687800232f5a772ca2e56e67187d8e54bba18"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4e8163b599bcd4f0c9277a8eedf687800232f5a772ca2e56e67187d8e54bba18"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4e8163b599bcd4f0c9277a8eedf687800232f5a772ca2e56e67187d8e54bba18"
    sha256 cellar: :any_skip_relocation, sonoma:        "e51db3ed1a747513b5592f56252341f98f03ab41522101f05011cefefa2eee87"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "23ac06e755309a41ac7481265556fc6ffd06fbf896e761339140c799a629ca4c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "25d7019935f928cf6fed5abc40eeb67bfcc1e8cc6a1ab507427bb91e64c3e688"
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