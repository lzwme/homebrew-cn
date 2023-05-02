class Fzf < Formula
  desc "Command-line fuzzy finder written in Go"
  homepage "https://github.com/junegunn/fzf"
  url "https://ghproxy.com/https://github.com/junegunn/fzf/archive/0.40.0.tar.gz"
  sha256 "9597f297a6811d300f619fff5aadab8003adbcc1566199a43886d2ea09109a65"
  license "MIT"
  head "https://github.com/junegunn/fzf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c69a4db1cb7809e1f33b139adbfced8dbe2a6f39a18f448cd16edf998cf93980"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c69a4db1cb7809e1f33b139adbfced8dbe2a6f39a18f448cd16edf998cf93980"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c69a4db1cb7809e1f33b139adbfced8dbe2a6f39a18f448cd16edf998cf93980"
    sha256 cellar: :any_skip_relocation, ventura:        "9dd75465057119dcdfce1c8ae82bfff0297aa78acbe887337927d0d955e85f25"
    sha256 cellar: :any_skip_relocation, monterey:       "9dd75465057119dcdfce1c8ae82bfff0297aa78acbe887337927d0d955e85f25"
    sha256 cellar: :any_skip_relocation, big_sur:        "9dd75465057119dcdfce1c8ae82bfff0297aa78acbe887337927d0d955e85f25"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "349a037c483ee911ff4cae95a6f5ea739c1d16345d9894de1cbfd1f220d6cea2"
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