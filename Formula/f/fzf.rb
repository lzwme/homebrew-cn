class Fzf < Formula
  desc "Command-line fuzzy finder written in Go"
  homepage "https:github.comjunegunnfzf"
  url "https:github.comjunegunnfzfarchiverefstagsv0.57.0.tar.gz"
  sha256 "d4e8e25fad2d3f75943b403c40b61326db74b705bf629c279978fdd0ceb1f97c"
  license "MIT"
  head "https:github.comjunegunnfzf.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f4936470e8ddcd195e4345557c51fd86015e81fd52b9ee3eefef66d37b16e10d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f4936470e8ddcd195e4345557c51fd86015e81fd52b9ee3eefef66d37b16e10d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f4936470e8ddcd195e4345557c51fd86015e81fd52b9ee3eefef66d37b16e10d"
    sha256 cellar: :any_skip_relocation, sonoma:        "afc798baf3dd3230d0fe570dcc682db1e11ec8a4f7e4012d8d49d46afbcaaf50"
    sha256 cellar: :any_skip_relocation, ventura:       "afc798baf3dd3230d0fe570dcc682db1e11ec8a4f7e4012d8d49d46afbcaaf50"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "278da1e0a4a8321b9b7a331e12717965741d8df9b2b0403118604a7635e93abe"
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