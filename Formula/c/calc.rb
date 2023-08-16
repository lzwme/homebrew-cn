class Calc < Formula
  desc "Arbitrary precision calculator"
  homepage "http://www.isthe.com/chongo/tech/comp/calc/"
  url "https://downloads.sourceforge.net/project/calc/calc/2.14.3.0/calc-2.14.3.0.tar.bz2"
  sha256 "e96913307bea79cb4796a62fb77bd9a8ded2924287fc1c17e3ba7fa5bceb3eaa"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_ventura:  "c7280827362673990fba887ff3abb12962097ccc4d5087cf1b84af67c5b82b91"
    sha256 arm64_monterey: "2781d9e2d450c9638a3aa3193b74884b01b85dd647295840b3c7a9d4d061bd85"
    sha256 arm64_big_sur:  "194f86dbf6e81df14cf3e56e958219f7329dd81b916b476a73f71e80e22b3796"
    sha256 ventura:        "90c57e99d6a78b783fe5e385067683eb515181dcb884ded192d523ff17a28417"
    sha256 monterey:       "7a08c4701637b914f1bf611782f9f6cdb7dda1f0779acc8d453543885d100138"
    sha256 big_sur:        "2f1ab91968a8335b4f17592bffee4e212847cc9d99999f4566fbb873a6e3214e"
    sha256 x86_64_linux:   "3ef3892a932c9b5a39ab5a4bf21a79f9d7b01be12f7fe92dd15a0724f35b64af"
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