class Libmicrohttpd < Formula
  desc "Light HTTP/1.1 server library"
  homepage "https://www.gnu.org/software/libmicrohttpd/"
  url "https://ftpmirror.gnu.org/gnu/libmicrohttpd/libmicrohttpd-1.0.7.tar.gz"
  mirror "https://ftp.gnu.org/gnu/libmicrohttpd/libmicrohttpd-1.0.7.tar.gz"
  sha256 "827250db649546cdb04bea01f5f0560f0edffde9130e256387d1f977242eaf98"
  license "LGPL-2.1-or-later"
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "ee3733b9d46f826584ff9a9024ff910cb5b4e80225d94b3226a1cc9244314017"
    sha256 cellar: :any, arm64_sequoia: "6022fcd3e0aa25f159854d8b4d06da178c161c0e097a5d6191ddf8dfcba5017b"
    sha256 cellar: :any, arm64_sonoma:  "45ca4d329ccc1c4c5323b448dac16d641e5256535b9c88d9e3675c68f481398f"
    sha256 cellar: :any, sonoma:        "987c6e30f168f968a0a1d0a0b398862280fdf1b41a3b06b4308abeadaff98082"
    sha256 cellar: :any, arm64_linux:   "8c69ed4eb7f9de1dce96a8897bee56521ce676271e480c3f01a8be589e8c8a0b"
    sha256 cellar: :any, x86_64_linux:  "b91fe6b0cf494fbf3deac7bfe4fef3a7e5657b4c44f1c76d20f61f5af5042e66"
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