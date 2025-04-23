class Fzf < Formula
  desc "Command-line fuzzy finder written in Go"
  homepage "https:github.comjunegunnfzf"
  url "https:github.comjunegunnfzfarchiverefstagsv0.61.3.tar.gz"
  sha256 "0a5837791dd0a9861ff778738ad174b1ad60968d2e196b4333bdcfb55567f37d"
  license "MIT"
  head "https:github.comjunegunnfzf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "66d7618610319e2d1b4b9a7d4ebeb240de2357c15819d1797c6bf5b8749b46ef"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "66d7618610319e2d1b4b9a7d4ebeb240de2357c15819d1797c6bf5b8749b46ef"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "66d7618610319e2d1b4b9a7d4ebeb240de2357c15819d1797c6bf5b8749b46ef"
    sha256 cellar: :any_skip_relocation, sonoma:        "a3edeab7100be518412947ca1374bb009363f03053e27ff39c61bf475774167c"
    sha256 cellar: :any_skip_relocation, ventura:       "a3edeab7100be518412947ca1374bb009363f03053e27ff39c61bf475774167c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1459cc64c43472d5934691f020b4a5a2dcfe6cfc58f4c8e9af8937a7fe9e1d0d"
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