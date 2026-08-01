class Libmicrohttpd < Formula
  desc "Light HTTP/1.1 server library"
  homepage "https://www.gnu.org/software/libmicrohttpd/"
  url "https://ftpmirror.gnu.org/gnu/libmicrohttpd/libmicrohttpd-1.0.9.tar.gz"
  mirror "https://ftp.gnu.org/gnu/libmicrohttpd/libmicrohttpd-1.0.9.tar.gz"
  sha256 "6e9adc446b08083ec03d40317fb66ca6f2e03e4f6170aef33a6e59bb08db2012"
  license "LGPL-2.1-or-later"
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "daba465c179c4b389905fc3acf1eaea165e6067c4fb2a46a8616cbb82eb6658e"
    sha256 cellar: :any, arm64_sequoia: "01880f8e245bc13341be25d7640bbd7d535421891008d20c3a887023b1f14cf1"
    sha256 cellar: :any, arm64_sonoma:  "1b3ab38b486ee8ded2bc484a0bbee8dfc8d680885db7c825979e9e60399df356"
    sha256 cellar: :any, sonoma:        "681d4febe75be4b699816583f78e212fd1e9e9ee0ba6f08e3dff89e101dd4719"
    sha256 cellar: :any, arm64_linux:   "73ce1081963902650f614b1b753a27e6014b94c11076107ebfdae0565b316281"
    sha256 cellar: :any, x86_64_linux:  "80c1e3d6e01e1954f6a70750ea5a44e382f4ed433b6f1429bc4ed2d24e61deda"
  end

  depends_on "pkgconf" => :build
  depends_on "gnutls"

  def install
    system "./configure", "--disable-silent-rules",
                          "--enable-https",
                          *std_configure_args
    system "make", "install"
    (pkgshare/"examples").install Dir.glob("doc/examples/*.c")
  end

  test do
    cp pkgshare/"examples/simplepost.c", testpath
    inreplace "simplepost.c",
      "return 0",
      "printf(\"daemon %p\", daemon) ; return 0"
    system ENV.cc, "-o", "foo", "simplepost.c", "-I#{include}", "-L#{lib}", "-lmicrohttpd"
    assert_match(/daemon 0x[0-9a-f]+[1-9a-f]+/, pipe_output("./foo"))
  end
end