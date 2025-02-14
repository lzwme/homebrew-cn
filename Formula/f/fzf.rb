class Fzf < Formula
  desc "Command-line fuzzy finder written in Go"
  homepage "https:github.comjunegunnfzf"
  url "https:github.comjunegunnfzfarchiverefstagsv0.60.0.tar.gz"
  sha256 "69255fd9301e491b6ac6788bf1caf5d4f70d9209b4b8ab70ceb1caf6a69b5c16"
  license "MIT"
  head "https:github.comjunegunnfzf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fe4d9d402b1de39bc6cff579e60a135feb334ce50ab112fa80a01de0e36a7bf7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fe4d9d402b1de39bc6cff579e60a135feb334ce50ab112fa80a01de0e36a7bf7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fe4d9d402b1de39bc6cff579e60a135feb334ce50ab112fa80a01de0e36a7bf7"
    sha256 cellar: :any_skip_relocation, sonoma:        "9dc07d8302fc1da725d28b38bb9cdf48f179625dd03d604c77155c9559c58ed3"
    sha256 cellar: :any_skip_relocation, ventura:       "9dc07d8302fc1da725d28b38bb9cdf48f179625dd03d604c77155c9559c58ed3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "25a86b33d2f452d95d8527391eb0c32fdfc3635021b477ff95f78584c266db38"
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