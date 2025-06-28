class Fzf < Formula
  desc "Command-line fuzzy finder written in Go"
  homepage "https:github.comjunegunnfzf"
  url "https:github.comjunegunnfzfarchiverefstagsv0.63.0.tar.gz"
  sha256 "f83287152726c5da0ea63ccbf83a0cd09ef8ac828976415b724c07337ed054b0"
  license "MIT"
  head "https:github.comjunegunnfzf.git", branch: "master"

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
    man1.install "manman1fzf.1", "manman1fzf-tmux.1"
    bin.install "binfzf-tmux"
    bin.install "binfzf-preview.sh"

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
      To set up shell integration, see:
        https:github.comjunegunnfzf#setting-up-shell-integration
      To use fzf in Vim, add the following line to your .vimrc:
        set rtp+=#{opt_prefix}
    EOS
  end

  test do
    (testpath"list").write %w[hello world].join($INPUT_RECORD_SEPARATOR)
    assert_equal "world", pipe_output("#{bin}fzf -f wld", (testpath"list").read).chomp
  end
end