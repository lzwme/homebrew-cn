class Calc < Formula
  desc "Arbitrary precision calculator"
  homepage "http://www.isthe.com/chongo/tech/comp/calc/"
  url "https://downloads.sourceforge.net/project/calc/calc/2.15.0.2/calc-2.15.0.2.tar.bz2"
  sha256 "74f123df64a247b46123d7c16bd9f2f7e104bae8974b65acc1170356e38c2577"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_sonoma:   "c09518c218a04c60e0421e033e59333edf09c2d7077da89ae28a35831231b4c5"
    sha256 arm64_ventura:  "54735e459f539ca6e6ef74f34f514a70fb832424b6783094b46f848c0f28b829"
    sha256 arm64_monterey: "e251c935a04af4d67e719db7b961bab2c20a333ccda404ea5ace5605d55dd93e"
    sha256 sonoma:         "ee0b299b6d459e67dbdbcd972684f12458116e0205d0cb3989a7019faadd637d"
    sha256 ventura:        "c526738f8790dc87ac6f683512de4e889b701f6a0f43da5362a0580ab31b5177"
    sha256 monterey:       "b4b72de4c731a170f652d06f7c7622e87bca210456e01e1868c4aa03329f3baf"
    sha256 x86_64_linux:   "f5c6def12d72cc071e3ca04f7bff9455fc9daf6240f46ac89b22633bdddc2b1b"
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