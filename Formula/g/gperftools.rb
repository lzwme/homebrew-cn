class Gperftools < Formula
  desc "Multi-threaded malloc() and performance analysis tools"
  homepage "https://github.com/gperftools/gperftools"
  url "https://ghfast.top/https://github.com/gperftools/gperftools/releases/download/gperftools-2.17/gperftools-2.17.tar.gz"
  sha256 "9661218de70c933dd8b296c6fd0f7c3993baa205ac5026961c1ed31716b79ae4"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/gperftools[._-]v?(\d+(?:\.\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "4bc932a66a8ed0a117d13b0e0d9d22a12d0611bdcaac938456bc6342dd2a11c0"
    sha256 cellar: :any,                 arm64_sonoma:  "a45a4a93f54731d8cf1ef439c9e4146a887db2c16c9119a024d044ea3c923457"
    sha256 cellar: :any,                 arm64_ventura: "90c1e3e7f25a618821c58f9864732d45a0715da0d082a2010e7fd7419fa1f349"
    sha256 cellar: :any,                 sonoma:        "c96ac8ca0224dfc79f7172f9dcbf41b36c2d3b28566f1de50636ce25e79fba14"
    sha256 cellar: :any,                 ventura:       "a38c8c470080c0362366bf75c61f6e06c2af05d3966984610a358e3ba5720119"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f3cf87a4a5ec5831a60c583deb6c5a5da10ee2243fbeacac22d177dd27cfbce6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d76a5b035e24779a01130569d2bd6817acbf8705612b59629a9357e168b9536c"
  end

  head do
    url "https://github.com/gperftools/gperftools.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  uses_from_macos "xz"

  on_linux do
    # libunwind is strongly recommended for Linux x86_64
    # https://github.com/gperftools/gperftools/blob/master/INSTALL
    depends_on "libunwind"
  end

  def install
    system "autoreconf", "--force", "--install", "--verbose" if build.head?

    args = [
      "--disable-dependency-tracking",
      "--prefix=#{prefix}",
    ]
    args << "--enable-libunwind" if OS.linux?

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <assert.h>
      #include <gperftools/tcmalloc.h>

      int main()
      {
        void *p1 = tc_malloc(10);
        assert(p1 != NULL);

        tc_free(p1);

        return 0;
      }
    C
    system ENV.cc, "test.c", "-L#{lib}", "-ltcmalloc", "-o", "test"
    system "./test"

    (testpath/"segfault.c").write <<~C
      #include <stdio.h>
      #include <stdlib.h>

      int main()
      {
        void *ptr = malloc(128);
        if (ptr == NULL) return 1;
        free(ptr);
        return 0;
      }
    C
    system ENV.cc, "segfault.c", "-L#{lib}", "-ltcmalloc", "-o", "segfault"
    system "./segfault"
  end
end