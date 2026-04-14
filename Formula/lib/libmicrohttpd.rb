class Libmicrohttpd < Formula
  desc "Light HTTP/1.1 server library"
  homepage "https://www.gnu.org/software/libmicrohttpd/"
  url "https://ftpmirror.gnu.org/gnu/libmicrohttpd/libmicrohttpd-1.0.4.tar.gz"
  mirror "https://ftp.gnu.org/gnu/libmicrohttpd/libmicrohttpd-1.0.4.tar.gz"
  sha256 "d72e5cfccd62bf2f79252edbc3828eeedc088ce71fc47b7c9e3bd7246b3d54de"
  license "LGPL-2.1-or-later"
  compatibility_version 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4175ff8a54eb307571e35dbf18da6efe603961beae455f483209ddd4ee3f1b9f"
    sha256 cellar: :any,                 arm64_sequoia: "0c4a4f16c64a6805656e0fe96a64b17da7f9343532b6b4a5d90cf096d96d469f"
    sha256 cellar: :any,                 arm64_sonoma:  "d8365a3642d2f84fdf31e18a786ddcdb6a9dc8dbb3b6263e9b594a72e177df7d"
    sha256 cellar: :any,                 sonoma:        "424a0be1ca6fa82d759e6b59a0098f605985bd6ef159fda700c0982c005c7845"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8243509f68af182b9305089b85a03590425191bf9cd35a72947e9d3012e9c843"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "114529a27653970bae292edbab4139249bf59de6272a7af545dbd218fcfcb7f7"
  end

  depends_on "gnutls"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--enable-https",
                          "--prefix=#{prefix}"
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