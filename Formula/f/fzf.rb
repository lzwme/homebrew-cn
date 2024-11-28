class Fzf < Formula
  desc "Command-line fuzzy finder written in Go"
  homepage "https:github.comjunegunnfzf"
  url "https:github.comjunegunnfzfarchiverefstagsv0.56.3.tar.gz"
  sha256 "fc7bf3fcfdc3c9562237d1e82196618201a39b3fd6bf3364149516b288f5a24a"
  license "MIT"
  head "https:github.comjunegunnfzf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5950deebde5f28640f560d325d24a2de3733ceee67018ea871bd892c72c7cc02"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5950deebde5f28640f560d325d24a2de3733ceee67018ea871bd892c72c7cc02"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5950deebde5f28640f560d325d24a2de3733ceee67018ea871bd892c72c7cc02"
    sha256 cellar: :any_skip_relocation, sonoma:        "d966b27087cf6f532ebfc3b0d049e4ef04378bd2b3c2c8381016b37c762b9e1a"
    sha256 cellar: :any_skip_relocation, ventura:       "d966b27087cf6f532ebfc3b0d049e4ef04378bd2b3c2c8381016b37c762b9e1a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4634fa4ef2deba42f297111e2f6a3104963d83a7d24767ccf6d2b9ce74ed9d13"
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