class Gperftools < Formula
  desc "Multi-threaded malloc() and performance analysis tools"
  homepage "https:github.comgperftoolsgperftools"
  url "https:github.comgperftoolsgperftoolsreleasesdownloadgperftools-2.14gperftools-2.14.tar.gz"
  sha256 "6b561baf304b53d0a25311bd2e29bc993bed76b7c562380949e7cb5e3846b299"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(gperftools[._-]v?(\d+(?:\.\d+)+)i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "6847fd8d9d941ff6a66519983d937f70a4b4cd5067afa8f2ed3bd441ea5181a4"
    sha256 cellar: :any,                 arm64_monterey: "379b58c0d89e71b802ec94ec3eb3dedb5e798a010c14479d1e902ecea5fa9ee7"
    sha256 cellar: :any,                 ventura:        "cc6c791a9e610d581528ec4fdf72a4d8ea45fdd30177bc2b04519fb7ef5a3422"
    sha256 cellar: :any,                 monterey:       "b8bc9958709893ca6598944f94f142c964fd684468abb2b54044f9b35f42da58"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "20ecddcacd32575b8306e066c64f6abe75ee95869d996d9ad1f9699b8750eb59"
  end

  head do
    url "https:github.comgperftoolsgperftools.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  uses_from_macos "xz"

  on_linux do
    # libunwind is strongly recommended for Linux x86_64
    # https:github.comgperftoolsgperftoolsblobmasterINSTALL
    depends_on "libunwind"
  end

  def install
    ENV.append_to_cflags "-D_XOPEN_SOURCE" if OS.mac?

    system "autoreconf", "--force", "--install", "--verbose" if build.head?

    args = [
      "--disable-dependency-tracking",
      "--prefix=#{prefix}",
    ]
    args << "--enable-libunwind" if OS.linux?

    system ".configure", *args
    system "make"
    system "make", "install"
  end

  test do
    (testpath"test.c").write <<~EOS
      #include <assert.h>
      #include <gperftoolstcmalloc.h>

      int main()
      {
        void *p1 = tc_malloc(10);
        assert(p1 != NULL);

        tc_free(p1);

        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-ltcmalloc", "-o", "test"
    system ".test"

    (testpath"segfault.c").write <<~EOS
      #include <stdio.h>
      #include <stdlib.h>

      int main()
      {
        void *ptr = malloc(128);
        if (ptr == NULL) return 1;
        free(ptr);
        return 0;
      }
    EOS
    system ENV.cc, "segfault.c", "-L#{lib}", "-ltcmalloc", "-o", "segfault"
    system ".segfault"
  end
end