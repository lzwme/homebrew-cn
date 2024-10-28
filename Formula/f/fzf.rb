class Fzf < Formula
  desc "Command-line fuzzy finder written in Go"
  homepage "https:github.comjunegunnfzf"
  url "https:github.comjunegunnfzfarchiverefstagsv0.56.0.tar.gz"
  sha256 "45880ac4175535bf1b298598fbc404ae8ad455ebde804ed5336237759507dc76"
  license "MIT"
  head "https:github.comjunegunnfzf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ef9174a5fc4c017e4d0b8206512a80ac14718fd01b7bddcc2f0a7f75bf93534b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ef9174a5fc4c017e4d0b8206512a80ac14718fd01b7bddcc2f0a7f75bf93534b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ef9174a5fc4c017e4d0b8206512a80ac14718fd01b7bddcc2f0a7f75bf93534b"
    sha256 cellar: :any_skip_relocation, sonoma:        "7d4f3a54d3cdc689255bec580befa0bd4a0700bfa4522ef20c3ac6f8e8208d9a"
    sha256 cellar: :any_skip_relocation, ventura:       "7d4f3a54d3cdc689255bec580befa0bd4a0700bfa4522ef20c3ac6f8e8208d9a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "81cfbe8b2ed036b77ba3ee31541d83eaa37357e1db729bcab47f807cb1014f0e"
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