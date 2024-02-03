class Calc < Formula
  desc "Arbitrary precision calculator"
  homepage "http://www.isthe.com/chongo/tech/comp/calc/"
  url "https://downloads.sourceforge.net/project/calc/calc/2.15.0.5/calc-2.15.0.5.tar.bz2"
  sha256 "4767a0247a1dbdc448a6bcb7390b8e625de2489b691575fa67d517c3377e63d4"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_sonoma:   "b2963a4ccf71b8cc36144a5663a9100c070106a072b4c9b2a3fbaa82f17c38d8"
    sha256 arm64_ventura:  "c31f28fa5cfe0b05006150dfa20f323c7f9a348b94b0ae7f317a7e7243e1603a"
    sha256 arm64_monterey: "6cba83f9cc06464fc21bd477770a431b707364fe9729f90f30bcd1686ca33f1a"
    sha256 sonoma:         "aaa21468fcfdea21d5b3eb0ac93c882fd4160460cd45f8a3e529dd870e080fac"
    sha256 ventura:        "c9ffca4833e470667f16d811911fffd15e191aea374ba4338edfcd98b2272d20"
    sha256 monterey:       "a003257b37efef9c8f105a2c6fccf4c00b4e7287514ce184590d89d8270ea61b"
    sha256 x86_64_linux:   "bea98f0d9d591a8d586b155e0c144df37a470e047be4043007d149b66a698fed"
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