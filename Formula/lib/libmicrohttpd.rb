class Libmicrohttpd < Formula
  desc "Light HTTP/1.1 server library"
  homepage "https://www.gnu.org/software/libmicrohttpd/"
  url "https://ftpmirror.gnu.org/gnu/libmicrohttpd/libmicrohttpd-1.0.8.tar.gz"
  mirror "https://ftp.gnu.org/gnu/libmicrohttpd/libmicrohttpd-1.0.8.tar.gz"
  sha256 "0763970a0e39f8f382123366e3cf5d03f70aa1e2208d3101e84da3e2cd674703"
  license "LGPL-2.1-or-later"
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "4bc0fb04efa827eabed6191586321124976198cb238466abcaef34f051ab1a68"
    sha256 cellar: :any, arm64_sequoia: "4f2986b0c137388dabd831b34aa6fd73a3d64f4d95aa63aaeff9720b4aca6216"
    sha256 cellar: :any, arm64_sonoma:  "695cd571dd22d11db48f24bef75d4555f2324ae55de51fdf4589a35fd42ff79b"
    sha256 cellar: :any, sonoma:        "781e5f3b5e5acc06e0e87b8b5b95fe146b553062807b6b08b68320cca88a8179"
    sha256 cellar: :any, arm64_linux:   "9d62a870d6b4a99e970115e07f2270906592c0a952d76991c4fcd28ae08580a3"
    sha256 cellar: :any, x86_64_linux:  "ece64ecd9565c6d4d2334f77f94b15c2f8bfd848b130707e876a1d65e5a88740"
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