class Fzf < Formula
  desc "Command-line fuzzy finder written in Go"
  homepage "https:github.comjunegunnfzf"
  url "https:github.comjunegunnfzfarchiverefstagsv0.60.1.tar.gz"
  sha256 "9252219096cf9a9dbf41fc177b9007ecafcfab4ff61ece8d78fee99cb9997bcc"
  license "MIT"
  head "https:github.comjunegunnfzf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "620066c45a518f97f816e533b295fbcd23f77b3a13ae863629e4915d5e442e65"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "620066c45a518f97f816e533b295fbcd23f77b3a13ae863629e4915d5e442e65"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "620066c45a518f97f816e533b295fbcd23f77b3a13ae863629e4915d5e442e65"
    sha256 cellar: :any_skip_relocation, sonoma:        "68341e0108c2af9eb00202bd3a5e36038d3ba80810640cf40cae585a3ed9a55f"
    sha256 cellar: :any_skip_relocation, ventura:       "68341e0108c2af9eb00202bd3a5e36038d3ba80810640cf40cae585a3ed9a55f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eb01fb8033ef9b6d4d76babbdf43ddb8f344974d50908805f30ed105a4659791"
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