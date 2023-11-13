class Fzf < Formula
  desc "Command-line fuzzy finder written in Go"
  homepage "https://github.com/junegunn/fzf"
  url "https://ghproxy.com/https://github.com/junegunn/fzf/archive/refs/tags/0.44.0.tar.gz"
  sha256 "cca886a7a49afa1d6269b752e97f6c5d2218ad2ee3eeea2ddeb06db1914e9b4e"
  license "MIT"
  head "https://github.com/junegunn/fzf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f72691cb022c04dca85a26210f0a0957da3884ee13694a7bca6e7c78296be1fe"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "572b48e9c989455fcc33fca8834a532113f5024f537fa096a58e69ce4981d086"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f4b5ce23aab38fb81d4ccbddc45b31a9646c3a3268840a63957a2054372224bf"
    sha256 cellar: :any_skip_relocation, sonoma:         "9695f6cb039e96f07ae80a40ef8e46aed0618f58821d54ba763935cd77744ede"
    sha256 cellar: :any_skip_relocation, ventura:        "35bf84cbccdc65319dc860cc07c171cf9c72cb7754f1fb33f13f8f39dbed1266"
    sha256 cellar: :any_skip_relocation, monterey:       "476d67f030faf9a596bcd4dd9f83ae40cf1509bd6d3db827cc434c704c08a3bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "38e922ba456ae3d970d0fbc919240b76f3c0200da71db6f33d3ee57ab6b72728"
  end

  depends_on "go" => :build

  uses_from_macos "ncurses"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version} -X main.revision=brew")
    man1.install "man/man1/fzf.1", "man/man1/fzf-tmux.1"
    bin.install "bin/fzf-tmux"

    # Please don't install these into standard locations (e.g. `zsh_completion`, etc.)
    # See: https://github.com/Homebrew/homebrew-core/pull/137432
    #      https://github.com/Homebrew/legacy-homebrew/pull/27348
    #      https://github.com/Homebrew/homebrew-core/pull/70543
    prefix.install "install", "uninstall"
    (prefix/"shell").install %w[bash zsh fish].map { |s| "shell/key-bindings.#{s}" }
    (prefix/"shell").install %w[bash zsh].map { |s| "shell/completion.#{s}" }
    (prefix/"plugin").install "plugin/fzf.vim"
  end

  def caveats
    <<~EOS
      To install useful keybindings and fuzzy completion:
        #{opt_prefix}/install

      To use fzf in Vim, add the following line to your .vimrc:
        set rtp+=#{opt_prefix}
    EOS
  end

  test do
    (testpath/"list").write %w[hello world].join($INPUT_RECORD_SEPARATOR)
    assert_equal "world", pipe_output("#{bin}/fzf -f wld", (testpath/"list").read).chomp
  end
end