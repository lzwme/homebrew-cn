class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://github.com/danielmiessler/fabric"
  url "https://ghfast.top/https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.407.tar.gz"
  sha256 "4f014c053ac3342a86a88713c987835da76a88403b987bf704bbc537ae39deb2"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "61971693300a61fd6730c3afc3d055355960616d0a7782ae6b17df1d197b125a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "61971693300a61fd6730c3afc3d055355960616d0a7782ae6b17df1d197b125a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "61971693300a61fd6730c3afc3d055355960616d0a7782ae6b17df1d197b125a"
    sha256 cellar: :any_skip_relocation, sonoma:        "430602363d20e08fce707517e9975241326b2538e788f760654de0f87d646100"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7aa71936e3868ee63a17b09715ad62f585be536b67b8697f1f7b4dd5f8872625"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2bb9b67786c5b0e975e6c9f2cc5440aab14b918256af4e684ab8a3274e8e0d23"
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