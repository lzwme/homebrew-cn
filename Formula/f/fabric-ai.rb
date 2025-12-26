class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://github.com/danielmiessler/fabric"
  url "https://ghfast.top/https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.363.tar.gz"
  sha256 "d1892751f4a34fa69dabb71071751d7c25a71cafbf5001394f6e80d523b3551b"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c98b5a9a7ec5bc600feb4d8f0ae05ecae1987b15fa88c6e848e390a4f2301e1f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c98b5a9a7ec5bc600feb4d8f0ae05ecae1987b15fa88c6e848e390a4f2301e1f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c98b5a9a7ec5bc600feb4d8f0ae05ecae1987b15fa88c6e848e390a4f2301e1f"
    sha256 cellar: :any_skip_relocation, sonoma:        "2c9823d8dc57658583a119902272bf7a4acf486995b8dc82e5315edf3b66a131"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f5128fb0ca7fb62a596d66486869cca7c75c030189b3d7da00fdeff23d1b2120"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1a91367f04b16296e4535e0a9b1efc2cf9593d7aacea7dad3cec11e6e0f92445"
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