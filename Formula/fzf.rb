class Fzf < Formula
  desc "Command-line fuzzy finder written in Go"
  homepage "https://github.com/junegunn/fzf"
  url "https://ghproxy.com/https://github.com/junegunn/fzf/archive/0.41.0.tar.gz"
  sha256 "12fdaaf0101c053596f98bd4789a048ea47d38c17a95f53a9bac793950cccc87"
  license "MIT"
  head "https://github.com/junegunn/fzf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d56ecaaede3f5e25d49bf67b49d2d20338afabe527de086997d16441a0866057"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d56ecaaede3f5e25d49bf67b49d2d20338afabe527de086997d16441a0866057"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d56ecaaede3f5e25d49bf67b49d2d20338afabe527de086997d16441a0866057"
    sha256 cellar: :any_skip_relocation, ventura:        "b92f35a4126875ac55702d95ac406f96d140148f64d9fa013e7d1dedfbd7ac29"
    sha256 cellar: :any_skip_relocation, monterey:       "b92f35a4126875ac55702d95ac406f96d140148f64d9fa013e7d1dedfbd7ac29"
    sha256 cellar: :any_skip_relocation, big_sur:        "b92f35a4126875ac55702d95ac406f96d140148f64d9fa013e7d1dedfbd7ac29"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d0ec9e8922e739cfd052d158ba707465b2610b0cef89e91810e8039923adfcea"
  end

  depends_on "go" => :build

  uses_from_macos "ncurses"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version} -X main.revision=brew")

    prefix.install "install", "uninstall"
    (prefix/"shell").install %w[bash zsh fish].map { |s| "shell/key-bindings.#{s}" }
    (prefix/"shell").install %w[bash zsh].map { |s| "shell/completion.#{s}" }
    (prefix/"plugin").install "plugin/fzf.vim"
    man1.install "man/man1/fzf.1", "man/man1/fzf-tmux.1"
    bin.install "bin/fzf-tmux"
  end

  def caveats
    <<~EOS
      To install useful keybindings and fuzzy completion:
        #{opt_prefix}/install

      To use fzf in Vim, add the following line to your .vimrc:
        set rtp+=#{opt_prefix}
    EOS
  end

  test do
    (testpath/"list").write %w[hello world].join($INPUT_RECORD_SEPARATOR)
    assert_equal "world", pipe_output("#{bin}/fzf -f wld", (testpath/"list").read).chomp
  end
end