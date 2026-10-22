class Gperftools < Formula
  desc "Multi-threaded malloc() and performance analysis tools"
  homepage "https://github.com/gperftools/gperftools"
  url "https://ghfast.top/https://github.com/gperftools/gperftools/releases/download/gperftools-2.19.1/gperftools-2.19.1.tar.gz"
  sha256 "4b0ac7a3803868685caa0ca4c190100ad8a302af6eb10b3e7482d36367f97309"
  license "BSD-3-Clause"
  compatibility_version 1

  livecheck do
    url :stable
    regex(/gperftools[._-]v?(\d+(?:\.\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "d0dd9a78846de2a079c11cb778b9b6f62e66fa9150c15bb6178dc01bf6e38d7f"
    sha256 cellar: :any, arm64_tahoe:       "2b58af0b84162b0d46e1d909542658688928f71ae0dee7196d97a55a1987b22e"
    sha256 cellar: :any, arm64_sequoia:     "3ba1d5dbc2df27877317dd264ee64b1ce919227f2f8ba6a9bad6cb71fb4dab4f"
    sha256 cellar: :any, arm64_linux:       "e42c1766f0042c368176b368d3bae5bcde2490a6d352c12b0bbc54b9cb13671f"
    sha256 cellar: :any, x86_64_linux:      "166f2776700e803f5be436177651716f14530370b74df1c4d627c759f09a245c"
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