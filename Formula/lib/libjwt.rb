class Libjwt < Formula
  desc "JSON Web Token C library"
  homepage "https:github.combenmcollinslibjwt"
  url "https:github.combenmcollinslibjwtreleasesdownloadv1.18.1libjwt-1.18.1.tar.bz2"
  sha256 "72039fb837c034b37f12111b037e8abc05724f8289c996e9ab2b1baa3b620644"
  license "MPL-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "b4c3cd3130a3bf99c5354a4ad4bf9ffb1667f42cb600da5c60faf1be2108417a"
    sha256 cellar: :any,                 arm64_sonoma:  "c4dcbf97fa57dd5671881bb7e5091446800c714c364bf0e00fceab54ea03fb1e"
    sha256 cellar: :any,                 arm64_ventura: "947c9d8c412eadd1aa927d3296d9fa5f26be6be11c5fe8fcb22bd9c0ed9f29a8"
    sha256 cellar: :any,                 sonoma:        "fe1d8f6bd8da36026fd3fffa6d13fca45ce9d45edb183326de6153e5f0db5c5b"
    sha256 cellar: :any,                 ventura:       "7bd485ff432a0c6b105a6f4c70fbf0c5bbd05e8032f6d3cab048a893dacfc634"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f771e0ff2c0061fecda61ab201b73345abe425122eab07cb0b116577703501ee"
  end

  head do
    url "https:github.combenmcollinslibjwt.git", branch: "master"

    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "autoconf" => :build
  depends_on "pkgconf" => :build
  depends_on "jansson"
  depends_on "openssl@3"

  def install
    system "autoreconf", "--force", "--install", "--verbose" if build.head?
    system ".configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath"test.c").write <<~C
      #include <stdlib.h>
      #include <jwt.h>

      int main() {
        jwt_t *jwt = NULL;
        if (jwt_new(&jwt) != 0) return 1;
        return 0;
      }
    C
    system ENV.cc, "test.c", "-L#{lib}", "-I#{include}", "-ljwt", "-o", "test"
    system ".test"
  end
end