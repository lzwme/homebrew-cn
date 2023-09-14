class Libevent < Formula
  desc "Asynchronous event library"
  homepage "https://libevent.org/"
  url "https://ghproxy.com/https://github.com/libevent/libevent/archive/release-2.1.12-stable.tar.gz"
  sha256 "7180a979aaa7000e1264da484f712d403fcf7679b1e9212c4e3d09f5c93efc24"
  license "BSD-3-Clause"
  revision 1

  livecheck do
    url :homepage
    regex(/libevent[._-]v?(\d+(?:\.\d+)+)-stable/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "38a3eb3510a7e0cd4096e4592d0095c562eb1bbad572d951f1923009a14ad702"
    sha256 cellar: :any,                 arm64_ventura:  "a75d453a7fe2aba1eaba334621b7bd9f0ff6f9e1f04aa400565f68711a9f6db4"
    sha256 cellar: :any,                 arm64_monterey: "a24d682548fb7cb11c127932240cced5d6fdb16feaaa6dc2ab3a7f0833e5df2e"
    sha256 cellar: :any,                 arm64_big_sur:  "0c3deccd564c0ed001cb3613ddc10d7e46e78deb5f8882fde74f8935557d5cba"
    sha256 cellar: :any,                 sonoma:         "5d54f13cd93d87185bd7bb592cb945d1f64cac3e88d1e46c2fb5d9ea538d9623"
    sha256 cellar: :any,                 ventura:        "79a1036d3428c6ad8325803912e9ff0f74b8a8202908ae8594959c27e998c90b"
    sha256 cellar: :any,                 monterey:       "d0557018f19021fb4675a20d9cefda5e13646558c276ab7b4f01f96144b432f8"
    sha256 cellar: :any,                 big_sur:        "042923957c025a4298465d320a63db6127414644fde58fcdc0d29e8c28fd2993"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "83ef4ce689a91f6fca013d6b4b0b2fcda3706080f8e0cccd056a3d94d6bc0f17"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "openssl@3"

  def install
    system "./autogen.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-debug-mode",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <event2/event.h>

      int main()
      {
        struct event_base *base;
        base = event_base_new();
        event_base_free(base);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-levent", "-o", "test"
    system "./test"
  end
end