class Fzf < Formula
  desc "Command-line fuzzy finder written in Go"
  homepage "https:github.comjunegunnfzf"
  url "https:github.comjunegunnfzfarchiverefstagsv0.56.1.tar.gz"
  sha256 "799c558628462fe0767ca282ed7e0746633239b80ab09ebc9d6f3653e3b788c9"
  license "MIT"
  head "https:github.comjunegunnfzf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3c747ca685eaf550b16ce2821e8de9d644097528d038ec75831e68a8fb0db088"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3c747ca685eaf550b16ce2821e8de9d644097528d038ec75831e68a8fb0db088"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3c747ca685eaf550b16ce2821e8de9d644097528d038ec75831e68a8fb0db088"
    sha256 cellar: :any_skip_relocation, sonoma:        "c73d3d0cb24a6ba14edd52438ee0c9d596dc02ab1ee967904af44e8be12d2ba7"
    sha256 cellar: :any_skip_relocation, ventura:       "c73d3d0cb24a6ba14edd52438ee0c9d596dc02ab1ee967904af44e8be12d2ba7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0b42230ce304e107a14964af87ed084f3a9545d65a7815d3bef7d960d386970c"
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