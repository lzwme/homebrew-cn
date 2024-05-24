class Bmake < Formula
  desc "Portable version of NetBSD make(1)"
  homepage "https://www.crufty.net/help/sjg/bmake.html"
  url "https://www.crufty.net/ftp/pub/sjg/bmake-20240520.tar.gz"
  sha256 "2210ccd455b008df7951f6dbd347bfcc1837c46473014e4b8dd5ff3091ae2894"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.crufty.net/ftp/pub/sjg/"
    regex(/href=.*?bmake[._-]v?(\d{6,8})\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f31776496532861ed29d617a6bc20fd8a79085556fbf005e33385b4c538ed0b1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "78f1abcd58e39827b9e4562f6d41f70e8c24eba3911bdda554b8f90a6c8492dd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7621a04c34d014cf570f5b98f90299eb5e661cb280256d9f71968c38834172e4"
    sha256                               sonoma:         "dbb8dfa83ecfa6c67fecbda62928bd293648e151388374ad81cd1695785f3c04"
    sha256                               ventura:        "6716cd52dac6284a75fae2d1fd447fca4f2ad83f82c792a299a7792408765026"
    sha256                               monterey:       "07b435a94528a0fe8ac19686681f24a92e664de0a285c0889fe2062d9568d356"
    sha256                               x86_64_linux:   "744f235efc8658eeb9e45182404b069179557c853b569d5e29dc972c9db6f463"
  end

  uses_from_macos "bc" => :build

  def install
    # -DWITHOUT_PROG_LINK means "don't symlink as bmake-VERSION."
    # shell-ksh test segfaults since macOS 11.
    args = ["--prefix=#{prefix}", "-DWITHOUT_PROG_LINK", "--install", "BROKEN_TESTS=shell-ksh"]
    system "sh", "boot-strap", *args

    man1.install "bmake.1"
  end

  test do
    (testpath/"Makefile").write <<~EOS
      all: hello

      hello:
      \t@echo 'Test successful.'

      clean:
      \trm -rf Makefile
    EOS
    system bin/"bmake"
    system bin/"bmake", "clean"
  end
end