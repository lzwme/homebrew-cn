class Fzf < Formula
  desc "Command-line fuzzy finder written in Go"
  homepage "https:github.comjunegunnfzf"
  url "https:github.comjunegunnfzfarchiverefstags0.49.0.tar.gz"
  sha256 "e3abb3afcfacf3dfea3144bf801c39fa51ee8ce65c1e8d8ff14521b3d7d2e249"
  license "MIT"
  head "https:github.comjunegunnfzf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "aa0ffe3f66ba44c9abe384f30a6a1fd1945a02fbf3ebdd28de772da69b182678"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "00d9f8ce734a571b6e738311c31f2a4ebc8e6f9d766392246741e577a74e63b1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "601b706d130821ad7cc41c914336da06a2e4d7295a9b8347d535b150600210ad"
    sha256 cellar: :any_skip_relocation, sonoma:         "319d7e7c9d886e9f5f8f59169e1cc51674a1c2b53f33cf38cc42c2127acba2e5"
    sha256 cellar: :any_skip_relocation, ventura:        "b388f737963853aa89d7cf5c88bdb95cd316a13d5f4d9216e891ebd845e7fcf2"
    sha256 cellar: :any_skip_relocation, monterey:       "c28898f6057b4ba0b99d3bb18c667fa5276cf6168802bb7fe2d87980effaed22"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e95cd810ccec9cdd85942514cacdeacaf38015c3af55d48a9c215abc4f876f6e"
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
        eval "$(fzf --zsh)"

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