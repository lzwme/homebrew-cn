class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://github.com/danielmiessler/fabric"
  url "https://ghfast.top/https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.333.tar.gz"
  sha256 "958f392a8ffd9a169ce2ac71a25df03238affdb64070b3f5688d9469c5271e06"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bf6fd34f7f72ad75d6de5233a7ab15b4a369fbfb466a12efaba22c107e86c9f8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bf6fd34f7f72ad75d6de5233a7ab15b4a369fbfb466a12efaba22c107e86c9f8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bf6fd34f7f72ad75d6de5233a7ab15b4a369fbfb466a12efaba22c107e86c9f8"
    sha256 cellar: :any_skip_relocation, sonoma:        "6659f884a7af85d911dff9b380aea20b4d2892ff086d1a8b65459c251e6e7fbb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5224503ec84bd435d3f9904823325b5cfe0e13e0266063e080fd5dd2ddfbea3c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "29a75b1e00cb7de7b436070b6bd98f6f2bebd7b6df6bd59d5539041bcb0f35b5"
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