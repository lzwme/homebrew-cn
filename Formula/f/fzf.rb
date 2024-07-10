class Fzf < Formula
  desc "Command-line fuzzy finder written in Go"
  homepage "https:github.comjunegunnfzf"
  url "https:github.comjunegunnfzfarchiverefstagsv0.54.0.tar.gz"
  sha256 "ce658b153254e25cf4244365d639cf3ac5b91230a20f76bd6845d88e1267a2db"
  license "MIT"
  head "https:github.comjunegunnfzf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "351a11f5ebd0f90ed0042e6b2799f0dc4f8ad3036ec657ec7c6cf99bfe28ab42"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b1f87a12d332a01a5031189b8ddd2cb1d5187a7448a0a7302f771fc9b207b971"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "67936242412bb96d9e3bcb3ecfd35262b8b16ff1f006c04ace8210f28a13c2a4"
    sha256 cellar: :any_skip_relocation, sonoma:         "f22b6db3a4fee6e2d8e92f148fb05eb7d9e91669bb92fde6d5e517f95e6142c8"
    sha256 cellar: :any_skip_relocation, ventura:        "e229e650a154fad8cd552ee4298ed417af392b9e442b50914f405de8bbe7d4df"
    sha256 cellar: :any_skip_relocation, monterey:       "bddda32dcb25a8019512d89a2958fbc1791a376e107a3546b600ef9e709bba8b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7398b1ac794f34e548bb753fcefd5b3980214b5358fa150e89b72aa9b7cba45f"
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