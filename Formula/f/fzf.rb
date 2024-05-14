class Fzf < Formula
  desc "Command-line fuzzy finder written in Go"
  homepage "https:github.comjunegunnfzf"
  url "https:github.comjunegunnfzfarchiverefstags0.52.1.tar.gz"
  sha256 "96848746ca78249c1fdd16f170776ce2f667097b60e4ffbd5ecdbd7dfac72ef9"
  license "MIT"
  head "https:github.comjunegunnfzf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "08672bc5edc69f7f2c1baf3179377218e49657beacccf5d59b0c8e338c98dd91"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cc791f731be60048f32e699009c290177d8eb9c01d132e6cc1f17480b8b744b5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7a65df316e698b60892a104fbc14cb05e8b7609197d7900cced22a37f70ad06e"
    sha256 cellar: :any_skip_relocation, sonoma:         "4a9b7fa9a68a1d02d4c4c8c4b31d3d1d943238de445edb6d66e3fa73543222c2"
    sha256 cellar: :any_skip_relocation, ventura:        "31e8d7a022ff35d822cbc188b4a8802ffa74c347916d714ad6515e3e11c4fd72"
    sha256 cellar: :any_skip_relocation, monterey:       "21b1748b50c54fc6b39a12e31d598f5825a35bd6ba1fe36a9865c087f3d226c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c94930e3f13691644c61f50681c3963b1660514d3ca7c16398bf08a167391b5e"
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