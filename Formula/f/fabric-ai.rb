class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://github.com/danielmiessler/fabric"
  url "https://ghfast.top/https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.471.tar.gz"
  sha256 "39a4e688deb7f7c6a8807cb699c5c97b26f7deff056110be42c50312e204e607"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e71083f85bb83cb780048253fb7c7ed7c8b0077bb278e550228a303fa4f7d261"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e71083f85bb83cb780048253fb7c7ed7c8b0077bb278e550228a303fa4f7d261"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e71083f85bb83cb780048253fb7c7ed7c8b0077bb278e550228a303fa4f7d261"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6ab06c4151e4dd06ac1557c84adf2f138a54f9d7474079855aa9403202a9cd0c"
    sha256 cellar: :any,                 x86_64_linux:  "450e77eb78f39e8b85b30472eded8db689d93c7d05a46a1519e194f3367d465d"
  end

  depends_on "go" => :build

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