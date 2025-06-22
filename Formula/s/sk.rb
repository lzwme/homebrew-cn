class Sk < Formula
  desc "Fuzzy Finder in rust!"
  homepage "https:github.comskim-rsskim"
  url "https:github.comskim-rsskimarchiverefstagsv0.19.0.tar.gz"
  sha256 "366da05e0e08fd765cc428d3007237b7960cc93f9d1a2462420fd57f40bea9d8"
  license "MIT"
  head "https:github.comskim-rsskim.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f7603b0471ba5c4386d7ba5cdaa0c07ed97cdbe774bffdb9739548e7cbb1c3fa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7176a261a5f936e4ad64ee15ec7c64403dee364ea640b6db1dcdae2e6350cf20"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "81e6201ed0ed52a1fed3e390586dd7c933bd33c6075fc226c57fe29e4843a9c6"
    sha256 cellar: :any_skip_relocation, sonoma:        "61cdf4ffc5d02d8ebea113b03862a9fb925138e3dc229180bd1c575bb5f4faa5"
    sha256 cellar: :any_skip_relocation, ventura:       "a1d2fc9aaab2dd999ca6dbe576441d1ebaa1d007fcda1242ed7eb1bcfa7ac176"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "365dec3516f93150d7a03733e3264da5db470e1767da2a01a9c5322136d19085"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "df0101aaa80fd441ccc509eb50d43b39497f2e48ede33a99e4ce647e3b4babf2"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "skim")

    pkgshare.install "install"
    bash_completion.install "shellkey-bindings.bash"
    bash_completion.install "shellcompletion.bash"
    fish_completion.install "shellkey-bindings.fish" => "skim.fish"
    zsh_completion.install "shellkey-bindings.zsh"
    zsh_completion.install "shellcompletion.zsh"
    man1.install "manman1sk.1", "manman1sk-tmux.1"
    bin.install "binsk-tmux"
  end

  test do
    assert_match(.*world, pipe_output("#{bin}sk -f wld", "hello\nworld"))
  end
end