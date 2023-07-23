class Calc < Formula
  desc "Arbitrary precision calculator"
  homepage "http://www.isthe.com/chongo/tech/comp/calc/"
  url "https://downloads.sourceforge.net/project/calc/calc/2.14.2.0/calc-2.14.2.0.tar.bz2"
  sha256 "6ef6499b128f409bea7e819d98a1a36efba0ef6a80e68ae691b481832166e74d"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_ventura:  "6ba5afb8adfbe3f3f11b0c20f1954cd51eda24950d2d0fea8078c5464715c09c"
    sha256 arm64_monterey: "e68eeea4a6d9a1dd02ef1a2cb2b2375234d21854bad1c89d398b4278762b5044"
    sha256 arm64_big_sur:  "a464d08a162eab21f5a218f41a792bde13e5060921b48710e23c9a0e38d4af59"
    sha256 ventura:        "ab2d44a8039808a37d83faca228391a9dbe4876ccb62897a12d862197bffccea"
    sha256 monterey:       "7fc7dc0cdbe3213e731db40d508bdce22ed07001b0c03e0ded9134a20a84bec0"
    sha256 big_sur:        "b527eee4ab821fe04123d61a5d700e3717a3abc5a055d3056b4f22ad2feb2c6e"
    sha256 x86_64_linux:   "51a38cd1ed3eea3b1de20f5a4073b82c944c92ecdb72cd1ce60ce9efd9e84354"
  end

  depends_on "readline"

  on_linux do
    depends_on "util-linux" # for `col`
  end

  def install
    ENV.deparallelize

    ENV["EXTRA_CFLAGS"] = ENV.cflags
    ENV["EXTRA_LDFLAGS"] = ENV.ldflags

    args = [
      "BINDIR=#{bin}",
      "LIBDIR=#{lib}",
      "MANDIR=#{man1}",
      "CALC_INCDIR=#{include}/calc",
      "CALC_SHAREDIR=#{pkgshare}",
      "USE_READLINE=-DUSE_READLINE",
      "READLINE_LIB=-L#{Formula["readline"].opt_lib} -lreadline",
      "READLINE_EXTRAS=-lhistory -lncurses",
    ]
    args << "INCDIR=#{MacOS.sdk_path}/usr/include" if OS.mac?
    system "make", "install", *args

    libexec.install "#{bin}/cscript"
  end

  test do
    assert_equal "11", shell_output("#{bin}/calc 0xA + 1").strip
  end
end