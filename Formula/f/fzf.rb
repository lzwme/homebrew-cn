class Fzf < Formula
  desc "Command-line fuzzy finder written in Go"
  homepage "https:github.comjunegunnfzf"
  url "https:github.comjunegunnfzfarchiverefstags0.45.0.tar.gz"
  sha256 "f0dd5548f80fe7f80d9277bb8fe252ac6e42a41e76fc85ce0f3af702cd987600"
  license "MIT"
  head "https:github.comjunegunnfzf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a8f9376459ca6c779c6e13ecb4962ac5157bb0f0cb46aba1fafe167cacd0544a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3cb10f3b66ed5747870525b88e527e2c8c5a2cae5c486438b3d449bb0b3554f6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6b5adb602f7cece57525a912d063d80d707b383688eaecf4507f83718270b4cc"
    sha256 cellar: :any_skip_relocation, sonoma:         "2901280f52bd99b2de6ef7b81218b6e8bb024306bd37024381a0a5ef06ccfd10"
    sha256 cellar: :any_skip_relocation, ventura:        "f24dadb0fa8af0f5b04dcac2494cea7283ec23a1bc54ec47500667918ddfa928"
    sha256 cellar: :any_skip_relocation, monterey:       "3550db8a9ef735ec6432f2462e651190a53aa4c9589ca9d5e5750aca118890ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d93c4dee31e49ddb62133aa872ba7d90b03a25094fabcac161663d0da7b96696"
  end

  depends_on "go" => :build

  uses_from_macos "ncurses"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version} -X main.revision=brew")
    man1.install "manman1fzf.1", "manman1fzf-tmux.1"
    bin.install "binfzf-tmux"

    # Please don't install these into standard locations (e.g. `zsh_completion`, etc.)
    # See: https:github.comHomebrewhomebrew-corepull137432
    #      https:github.comHomebrewlegacy-homebrewpull27348
    #      https:github.comHomebrewhomebrew-corepull70543
    prefix.install "install", "uninstall"
    (prefix"shell").install %w[bash zsh fish].map { |s| "shellkey-bindings.#{s}" }
    (prefix"shell").install %w[bash zsh].map { |s| "shellcompletion.#{s}" }
    (prefix"plugin").install "pluginfzf.vim"
  end

  def caveats
    <<~EOS
      To install useful keybindings and fuzzy completion:
        #{opt_prefix}install

      To use fzf in Vim, add the following line to your .vimrc:
        set rtp+=#{opt_prefix}
    EOS
  end

  test do
    (testpath"list").write %w[hello world].join($INPUT_RECORD_SEPARATOR)
    assert_equal "world", pipe_output("#{bin}fzf -f wld", (testpath"list").read).chomp
  end
end