class Nnn < Formula
  desc "Tiny, lightning fast, feature-packed file manager"
  homepage "https://github.com/jarun/nnn"
  url "https://ghproxy.com/https://github.com/jarun/nnn/archive/refs/tags/v4.9.tar.gz"
  sha256 "9e25465a856d3ba626d6163046669c0d4010d520f2fb848b0d611e1ec6af1b22"
  license "BSD-2-Clause"
  head "https://github.com/jarun/nnn.git", branch: "master"

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_sonoma:   "e95d6dabf1c2978ce3b79af2367b1e8ff807004407ca2f5f8213388da8b10057"
    sha256 cellar: :any,                 arm64_ventura:  "319f05996936a704db7db659cd48932954f64bf9778d9ec6c84d54560d101310"
    sha256 cellar: :any,                 arm64_monterey: "732cbc35409a1978427871bfc7d1779bde7de7e200b923e91a851bfeb559e858"
    sha256 cellar: :any,                 sonoma:         "58ba8428aa041974ae10c6c55ab19ef58de94184a9635672f04c50cde56f7d08"
    sha256 cellar: :any,                 ventura:        "da8e698ff9288e4c5eacc7008edb7d5d30338ff28cad6828c01c42a728be1d5b"
    sha256 cellar: :any,                 monterey:       "2c8f93e2a63d06cf6182bb2cb88cef079cf3bf5d3ec61355c6c6690595fe3903"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fd28af47ecbf2a496af613441d751d4b491a111d56a8511a4a7719138b4debdc"
  end

  depends_on "gnu-sed"
  depends_on "ncurses"
  depends_on "readline"

  def install
    args = %w[
      O_NERD=1
    ]
    # args: choose one of O_NERD/O_EMOJI/O_ICONS

    system "make", "install", "PREFIX=#{prefix}", *args

    bash_completion.install "misc/auto-completion/bash/nnn-completion.bash"
    zsh_completion.install "misc/auto-completion/zsh/_nnn"
    fish_completion.install "misc/auto-completion/fish/nnn.fish"

    pkgshare.install "misc/quitcd"
  end

  test do
    # Test fails on CI: Input/output error @ io_fread - /dev/pts/0
    # Fixing it involves pty/ruby voodoo, which is not worth spending time on
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    # Testing this curses app requires a pty
    require "pty"

    (testpath/"testdir").mkdir
    PTY.spawn(bin/"nnn", testpath/"testdir") do |r, w, _pid|
      w.write "q"
      assert_match "~/testdir", r.read
    end
  end
end