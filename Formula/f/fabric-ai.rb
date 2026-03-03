class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://github.com/danielmiessler/fabric"
  url "https://ghfast.top/https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.428.tar.gz"
  sha256 "b29a63f85b765a3881e15c1bec4e427d4e375237aa16de0380511d57f64a0f97"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f7b087bb2af535927b52f1869c9ef0fba17cc5667b1ac85f5ab44ac1e98765e1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f7b087bb2af535927b52f1869c9ef0fba17cc5667b1ac85f5ab44ac1e98765e1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f7b087bb2af535927b52f1869c9ef0fba17cc5667b1ac85f5ab44ac1e98765e1"
    sha256 cellar: :any_skip_relocation, sonoma:        "e6210715889f4fe8cfce848be368033ec43f8eb2a7da3a741d8d1ccef75c83bf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "37413fbc3cde6ef668d038b646e6af51d725289dd3e63a894ab93afaa3ab5b24"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c3a400f5f76f916d84a93b7e814d0016c0f1fe324930c69df3afd6a59d63312d"
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