class Cheat < Formula
  desc "Create and view interactive cheat sheets for *nix commands"
  homepage "https://github.com/cheat/cheat"
  url "https://ghproxy.com/https://github.com/cheat/cheat/archive/refs/tags/4.4.1.tar.gz"
  sha256 "cca7f3d631de38ef1b4f36a5dc76d52d091611d38074ff2522a1a8b36f34a182"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f7bc9aba99f604922bc5b69aba26b9f9928a88afeae42d8612fdcdec0eea3d2d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6f134d0bbae33ef70a1527bdffb2c51d34250fcf91c6e925229691b04ca450ad"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "42bb66f903c43e63ec5809b136269466b81566ba9b8ba249d6aed8ab690bd11f"
    sha256 cellar: :any_skip_relocation, sonoma:         "68e06cd9957868388660687ef8a72340af93530bb1a0b6c7ac56d8dba483b4a4"
    sha256 cellar: :any_skip_relocation, ventura:        "1fae43661c5873803663bcb43782a5626b3a46819459da8555eabcf666ebdfd0"
    sha256 cellar: :any_skip_relocation, monterey:       "a8cdcb79b5796c47b621b0c73a67f5dc0c8e055eab6ea57ab8fc8ca22e243f86"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a80ea9257cd60c6d0b2851253dca74f268dc70e9749aa86e8dbd139414200a87"
  end

  depends_on "go" => :build

  conflicts_with "bash-snippets", because: "both install a `cheat` executable"

  def install
    system "go", "build", "-mod", "vendor", "-o", bin/"cheat", "./cmd/cheat"

    bash_completion.install "scripts/cheat.bash"
    fish_completion.install "scripts/cheat.fish"
    zsh_completion.install "scripts/cheat.zsh"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cheat --version")

    output = shell_output("#{bin}/cheat --init 2>&1")
    assert_match "editor: EDITOR_PATH", output
  end
end