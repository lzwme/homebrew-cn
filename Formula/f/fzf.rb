class Fzf < Formula
  desc "Command-line fuzzy finder written in Go"
  homepage "https:github.comjunegunnfzf"
  url "https:github.comjunegunnfzfarchiverefstagsv0.54.1.tar.gz"
  sha256 "62358508afdf3840ab63ae06fbc86382a407362cf9491788e6aa52215a98b68f"
  license "MIT"
  head "https:github.comjunegunnfzf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cbd28ed168c1fecd7bd08c595868c91ff87edc513e52022741285718f1d86264"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "80fd1d6d0d8979b5b563614e1bf085e10a26fa8778c2f7a23d3dd555414349fa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8798e1fabf9a5185c2831abe19b7d03a100869a54fcc5f1bcc406be7f738014e"
    sha256 cellar: :any_skip_relocation, sonoma:         "8ad6d5f0bf85a60ae20c69cdfe877a138328a3730ebeb1041fc5fa2f4228bb6f"
    sha256 cellar: :any_skip_relocation, ventura:        "352948be36a67c14cf3b872d60add3393696c26813ef72fb7c7ef19f8d56a9f5"
    sha256 cellar: :any_skip_relocation, monterey:       "f0e6c1832c1d13248090b190c1561b0c6a5be44887c1b996f74bc58a5c1bfeda"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7dfd37f3a1b7444129bce27518659e72087c6b3eb60f1834b05ea7975d560082"
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
      To set up shell integration, add this to your shell configuration file:
        # bash
        eval "$(fzf --bash)"

        # zsh
        source <(fzf --zsh)

        # fish
        fzf --fish | source

      To use fzf in Vim, add the following line to your .vimrc:
        set rtp+=#{opt_prefix}
    EOS
  end

  test do
    (testpath"list").write %w[hello world].join($INPUT_RECORD_SEPARATOR)
    assert_equal "world", pipe_output("#{bin}fzf -f wld", (testpath"list").read).chomp
  end
end