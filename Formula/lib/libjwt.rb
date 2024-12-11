class Libjwt < Formula
  desc "JSON Web Token C library"
  homepage "https:github.combenmcollinslibjwt"
  url "https:github.combenmcollinslibjwtreleasesdownloadv2.1.0libjwt-2.1.0.tar.bz2"
  sha256 "4c48761179153d144b7904e9b5e6e705387bbe0954237e9b0bee59cbf781ac68"
  license "MPL-2.0"
  head "https:github.combenmcollinslibjwt.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "bb169c491462466ddb3dec158788c251fd498ca6f648cabd1df44555ffc68ac8"
    sha256 cellar: :any,                 arm64_sonoma:  "ed465a326a3345dff926dda0a2d98a2f3124e19a8af36b34d3c8e7902152214b"
    sha256 cellar: :any,                 arm64_ventura: "7c67c24c7d3f6022c1cdcc207a0843c009bba4584d7f6689270c0adb31511198"
    sha256 cellar: :any,                 sonoma:        "ab6c029ef43730d2cf81885df962a14b8d1ebe27ea082bd5ddebdd121e30505c"
    sha256 cellar: :any,                 ventura:       "d3de2a610d6c5a32835b73196a295f24de757b215e6aa29df6538eff3f161e56"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5121b0f68c25e5432ab8caa01e0cb5fba6630bfcd3a10eca0897c89273d90d89"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "gnutls"
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