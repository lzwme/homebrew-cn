class Libssh2 < Formula
  desc "C library implementing the SSH2 protocol"
  homepage "https://www.libssh2.org/"
  url "https://www.libssh2.org/download/libssh2-1.11.0.tar.gz"
  mirror "https://ghproxy.com/https://github.com/libssh2/libssh2/releases/download/libssh2-1.11.0/libssh2-1.11.0.tar.gz"
  mirror "http://download.openpkg.org/components/cache/libssh2/libssh2-1.11.0.tar.gz"
  sha256 "3736161e41e2693324deb38c26cfdc3efe6209d634ba4258db1cecff6a5ad461"
  license "BSD-3-Clause"
  revision 1

  livecheck do
    url "https://www.libssh2.org/download/"
    regex(/href=.*?libssh2[._-]v?(\d+(?:\.\d+)+)\./i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "41e860bcf96b8e86bb5f2c321fb1ca14b620adce510cec881eeac2f432e00e5e"
    sha256 cellar: :any,                 arm64_monterey: "cc09eb9988f274f2f923aa1d047a6df28fc5fe5d5301f9bde8e0df44167dbb29"
    sha256 cellar: :any,                 arm64_big_sur:  "80ec45fff392d1ea106aaceaf6f35fb96847a59ad378ae9e83aecc9470a384a9"
    sha256 cellar: :any,                 ventura:        "71b9199fd292ab344d388051629500329315e37c20e7329b5c1c6772beed42be"
    sha256 cellar: :any,                 monterey:       "9a4b09c1a5b50b847b0104a0976c8d6359de9f567928f57c1a4eae84e6f7134a"
    sha256 cellar: :any,                 big_sur:        "41dbed0ea860e38eb76d1a5fb0b68c06d86035a386e138bb50df03dd61803794"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "57746d26d6d96b0ba3a7b7021b8f13a466685e8a2172fa49bf4cb44d91d24429"
  end

  head do
    url "https://github.com/libssh2/libssh2.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "openssl@3"

  uses_from_macos "zlib"

  def install
    args = %W[
      --disable-silent-rules
      --disable-examples-build
      --with-openssl
      --with-libz
      --with-libssl-prefix=#{Formula["openssl@3"].opt_prefix}
    ]

    system "./buildconf" if build.head?
    system "./configure", *std_configure_args, *args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <libssh2.h>

      int main(void)
      {
      libssh2_exit();
      return 0;
      }
    EOS

    system ENV.cc, "test.c", "-L#{lib}", "-lssh2", "-o", "test"
    system "./test"
  end
end