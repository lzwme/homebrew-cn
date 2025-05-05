class Fzf < Formula
  desc "Command-line fuzzy finder written in Go"
  homepage "https:github.comjunegunnfzf"
  url "https:github.comjunegunnfzfarchiverefstagsv0.62.0.tar.gz"
  sha256 "e5beae86a3d026b2c2cfc165715d45b831b9f337a9e96f711ba3bc3d15e50900"
  license "MIT"
  head "https:github.comjunegunnfzf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "af76ab424bb56e5a9db035553cf5ebbb3f3949ace449ac5e8353dbe9776c2336"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "af76ab424bb56e5a9db035553cf5ebbb3f3949ace449ac5e8353dbe9776c2336"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "af76ab424bb56e5a9db035553cf5ebbb3f3949ace449ac5e8353dbe9776c2336"
    sha256 cellar: :any_skip_relocation, sonoma:        "5187308e01d4ead92385ddfb6e8290d5301fbc0eda01596304a5ba29b960eb3e"
    sha256 cellar: :any_skip_relocation, ventura:       "5187308e01d4ead92385ddfb6e8290d5301fbc0eda01596304a5ba29b960eb3e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "826ac62a23865713b1360a8ff63e6c3cfdb3f30f6f7d1b516c91799be3d91553"
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