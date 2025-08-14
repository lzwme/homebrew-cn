class Gperftools < Formula
  desc "Multi-threaded malloc() and performance analysis tools"
  homepage "https://github.com/gperftools/gperftools"
  url "https://ghfast.top/https://github.com/gperftools/gperftools/releases/download/gperftools-2.17.1/gperftools-2.17.1.tar.gz"
  sha256 "7c0e083a4d321c25d8122ba35baa16e9dcd75ffd93e88002f6fb9664a19a9bda"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/gperftools[._-]v?(\d+(?:\.\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "9e729297c799dd8a2acffbe076dcb2171de1c03c1a5219da3e910e5b2cabd7da"
    sha256 cellar: :any,                 arm64_sonoma:  "bcb1b349d7f66b7798c357bb6b699f2d43100502b6fed332932cc3cca1c8b14f"
    sha256 cellar: :any,                 arm64_ventura: "d452ee627145261f8fae0e4655029f34866dbdd334674fbe4bfb9fc716a54314"
    sha256 cellar: :any,                 sonoma:        "19dbae04a8cd0e9f14f8c34c47c8ece3e8e2bc07473153f8d16ab284598cd46b"
    sha256 cellar: :any,                 ventura:       "43766c3c9c9858d7897f00dc84a309fdd65a83190e130b035bb175a2228137e0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f972bfb5dd5eb2aa43a754fca3e3dc0995d24dca3407a979effbf2cdf8405c27"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "09b54008898a22873beebe1133436037934187cc9bd5dc790bdfec096241a1ab"
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