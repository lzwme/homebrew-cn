class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://github.com/danielmiessler/fabric"
  url "https://ghfast.top/https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.524.tar.gz"
  sha256 "fff170d26d36f78fff457dd671f71c6077611711bc99de0af89c40d6ce7c9ede"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "03cd1acf3e409052f1890008e7196322ede96e7e55fea94f5dd6bb2712490811"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "03cd1acf3e409052f1890008e7196322ede96e7e55fea94f5dd6bb2712490811"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "03cd1acf3e409052f1890008e7196322ede96e7e55fea94f5dd6bb2712490811"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "4f3cd5a8321028b86c2f03c2d2cd3c7b806bfb32cd75cb69de9a344a4b025894"
    sha256 cellar: :any,                 x86_64_linux:      "2f3099f4d6f0083a6e7c4d190319ed78f32df58d4f5d198a6f3622c398773f0f"
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