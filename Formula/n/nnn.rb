class Nnn < Formula
  desc "Tiny, lightning fast, feature-packed file manager"
  homepage "https://github.com/jarun/nnn"
  url "https://ghproxy.com/https://github.com/jarun/nnn/archive/refs/tags/v4.9.tar.gz"
  sha256 "9e25465a856d3ba626d6163046669c0d4010d520f2fb848b0d611e1ec6af1b22"
  license "BSD-2-Clause"
  head "https://github.com/jarun/nnn.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "c8743d31f512639a6424da5c9f37fbfd2c7cb3de66eddba2d697abac4cefc953"
    sha256 cellar: :any,                 arm64_ventura:  "5f13d617bef10862e45d3a1234a9fb515cb91f665286620b739c1a270830ce5c"
    sha256 cellar: :any,                 arm64_monterey: "b1898d5e9926e2645a017442cfa66fc3a8b6a0814fc18bdbf7a70f561c2552f4"
    sha256 cellar: :any,                 sonoma:         "6426f4ac716e4203e1dc6cea5018af7f7bc1225dfc602c19fc6af9a7ce2f09de"
    sha256 cellar: :any,                 ventura:        "f55965fd3c847e11d74e902214a509456e1c940c9d37a6ccd78f15ca1cb5128d"
    sha256 cellar: :any,                 monterey:       "31de38134834caa63a2a27d42c0945a97ae13f3f7ca153fae61be4f0f7c3d724"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "503611604b9999f9f9ed73db027403b4ee20f5039c8278e99f47bdd23c9c291c"
  end

  depends_on "gnu-sed"
  depends_on "ncurses"
  depends_on "readline"

  def install
    args = %w[
      O_EMOJI=1
      O_NERD=1
      O_ICONS=1
    ]

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