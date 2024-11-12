class Fzf < Formula
  desc "Command-line fuzzy finder written in Go"
  homepage "https:github.comjunegunnfzf"
  url "https:github.comjunegunnfzfarchiverefstagsv0.56.2.tar.gz"
  sha256 "1d67edb3e3ffbb14fcbf786bfcc0b5b8d87db6a0685135677b8ef4c114d2b864"
  license "MIT"
  head "https:github.comjunegunnfzf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dd4a7f3e3c170616285a134aeb2faf630406ff6f65790129ba0c8701c69d319b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dd4a7f3e3c170616285a134aeb2faf630406ff6f65790129ba0c8701c69d319b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "dd4a7f3e3c170616285a134aeb2faf630406ff6f65790129ba0c8701c69d319b"
    sha256 cellar: :any_skip_relocation, sonoma:        "620ef3d40401dab2e808f704116599c2da0d0b96d0a48619c0eaea31e23cb84f"
    sha256 cellar: :any_skip_relocation, ventura:       "620ef3d40401dab2e808f704116599c2da0d0b96d0a48619c0eaea31e23cb84f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c5ad1222f75ee38392212005255f80100aa6b3c042232bf6de391412428db424"
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