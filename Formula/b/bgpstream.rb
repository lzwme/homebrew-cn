class Bgpstream < Formula
  desc "For live and historical BGP data analysis"
  homepage "https:bgpstream.caida.org"
  url "https:github.comCAIDAlibbgpstreamreleasesdownloadv2.2.0libbgpstream-2.2.0.tar.gz"
  sha256 "db7926c099972468f1a2f98f1aea9a5a1760d1f744ff6966b79bbcc6651bdb69"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "a5c07060d0fd8a5a1e77cb7af35c8dd53c2ca1a81260dfb97ed07657d395d88f"
    sha256 cellar: :any,                 arm64_ventura:  "8a38b4170f93d827af8e7af8f3973897209dcf115ac8d0cc19d6d835e59e712d"
    sha256 cellar: :any,                 arm64_monterey: "e789878a243b35c33bf72594d808b5528b182b18299231fee79f3a046b766c48"
    sha256 cellar: :any,                 arm64_big_sur:  "5c28bee02acc7bc557119b71bc714a9a505aa91ef58d2e390c6d7f75753d0f25"
    sha256 cellar: :any,                 sonoma:         "913466b5947677dcaf1877e21b4a75f5c3f8b2a5c878abdb7971d0a78e8b1e20"
    sha256 cellar: :any,                 ventura:        "dcfa79536b869e246ee73e8e7f645e8fb41ead10578bb472dabd737148b56fe8"
    sha256 cellar: :any,                 monterey:       "ff5d659c719347cfc6ab6208b5341a0a79d457c47dd92f74e4bc44d757608ffa"
    sha256 cellar: :any,                 big_sur:        "950968b0578b8d4131574c5fd985f56a1e10abd2d4aabdeeb408db2b323d6567"
    sha256 cellar: :any,                 catalina:       "a684f4249475c2c0531fda4467adbba15b8e07c4e49b8ffc0366cae16fc76888"
    sha256 cellar: :any,                 mojave:         "80262121246eb9431bedf0a64a12448ca1f2387caf17a8c1c7f20eaca6ca1069"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "da7354b8e52ae543d5e48aa9a7f2c1725f95c7581e8006c02845da8fcd3b78c5"
  end

  depends_on "librdkafka"
  depends_on "wandio"

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https:raw.githubusercontent.comHomebrewformula-patches03cf8088210822aa2c1ab544ed58ea04c897d9c4libtoolconfigure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
  end

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https:raw.githubusercontent.comHomebrewformula-patches03cf8088210822aa2c1ab544ed58ea04c897d9c4libtoolconfigure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
    directory "libformatslibparsebgp"
  end

  def install
    system ".configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath"test.c").write <<~EOS
      #include <stdio.h>
      #include "bgpstream.h"
      int main()
      {
        bgpstream_t *bs = bs = bgpstream_create();
        if(!bs) {
          return -1;
        }
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lbgpstream", "-o", "test"
    system ".test"
  end
end