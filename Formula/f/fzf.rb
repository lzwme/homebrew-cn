class Fzf < Formula
  desc "Command-line fuzzy finder written in Go"
  homepage "https://github.com/junegunn/fzf"
  url "https://ghfast.top/https://github.com/junegunn/fzf/archive/refs/tags/v0.63.0.tar.gz"
  sha256 "f83287152726c5da0ea63ccbf83a0cd09ef8ac828976415b724c07337ed054b0"
  license "MIT"
  head "https://github.com/junegunn/fzf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cf9a3399a7e7e07cbd3d790def2da454dd25a34d6c8ea89ec3b1dacaa10ab123"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cf9a3399a7e7e07cbd3d790def2da454dd25a34d6c8ea89ec3b1dacaa10ab123"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cf9a3399a7e7e07cbd3d790def2da454dd25a34d6c8ea89ec3b1dacaa10ab123"
    sha256 cellar: :any_skip_relocation, sonoma:        "27393e6582088763e94e5912913ac0c59d58196fa0d256f8d2aab27830edf040"
    sha256 cellar: :any_skip_relocation, ventura:       "27393e6582088763e94e5912913ac0c59d58196fa0d256f8d2aab27830edf040"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "669a51c4c44a4be33204a55a2f5f5b5c98e6a21b76cf3b608d3ac88a854dccfe"
  end

  depends_on "go" => :build

  uses_from_macos "ncurses"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version} -X main.revision=brew")
    man1.install "man/man1/fzf.1", "man/man1/fzf-tmux.1"
    bin.install "bin/fzf-tmux"
    bin.install "bin/fzf-preview.sh"

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
      To set up shell integration, see:
        https://github.com/junegunn/fzf#setting-up-shell-integration
      To use fzf in Vim, add the following line to your .vimrc:
        set rtp+=#{opt_prefix}
    EOS
  end

  test do
    (testpath/"list").write %w[hello world].join($INPUT_RECORD_SEPARATOR)
    assert_equal "world", pipe_output("#{bin}/fzf -f wld", (testpath/"list").read).chomp
  end
end