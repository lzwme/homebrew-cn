class Nnn < Formula
  desc "Tiny, lightning fast, feature-packed file manager"
  homepage "https://github.com/jarun/nnn"
  url "https://ghproxy.com/https://github.com/jarun/nnn/archive/v4.7.tar.gz"
  sha256 "81ccccc045bfd7ee3f1909cc443158ea0d1833f77d6342fd19c33864a2ab71d1"
  license "BSD-2-Clause"
  head "https://github.com/jarun/nnn.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "b094737033cd0233f38f8e41a7456845476254d28f1f09f99a00c7137febb2d5"
    sha256 cellar: :any,                 arm64_monterey: "a8606857ab2c09c190e646eab0293f9719ffc99e1621a461ca9626d0cd615469"
    sha256 cellar: :any,                 arm64_big_sur:  "8c95d96c404d49745917163ecb0f32b7d5bf9d40b57a937e445c2b641bacdf10"
    sha256 cellar: :any,                 ventura:        "f98ea7c028bdb177be92a9723043f06b9ed76f0aada9874bf26867d8f6e7df08"
    sha256 cellar: :any,                 monterey:       "cba73b2adad9140050a6c979f616f9c82c53429d6180a5c6586cef7dfe7e376d"
    sha256 cellar: :any,                 big_sur:        "4ca5efbe940a5776bf6d5ba5834f7012c80076879bc3c4be5f5e24f95c1e129b"
    sha256 cellar: :any,                 catalina:       "20c3bb236113c28d9c6cc9a96cf1440e66ee58278f97af0e908c32cc6595e537"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "43f2d21629ca07752e91f59a504f6890ac8abac000d82f3448c2b7c6bc82710f"
  end

  depends_on "gnu-sed"
  depends_on "ncurses"
  depends_on "readline"

  def install
    system "make", "install", "PREFIX=#{prefix}"

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