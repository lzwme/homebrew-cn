class Libjwt < Formula
  desc "JSON Web Token C library"
  homepage "https:github.combenmcollinslibjwt"
  url "https:github.combenmcollinslibjwtreleasesdownloadv2.0.0libjwt-2.0.0.tar.bz2"
  sha256 "1d4f1b161fb0bd0b84ba4dcb25958365e4c1ed21f8ce9a9c01509f875410d777"
  license "MPL-2.0"
  head "https:github.combenmcollinslibjwt.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "b35d13522936ea2b2ac894d7c166d9194dd0a292f8b62f79751da73eaafd6a85"
    sha256 cellar: :any,                 arm64_sonoma:  "4015d9c72253e8fee7f675e1c67fa0e6c1ca5ca7c71c2a370c86efc0708cbb47"
    sha256 cellar: :any,                 arm64_ventura: "b62e666d854f735470d182416800644ba6c1197a2758158b69564eabb2856101"
    sha256 cellar: :any,                 sonoma:        "972314435cf8d9940c9188c60e6f1c301e436e210bd029322427242a15a7716d"
    sha256 cellar: :any,                 ventura:       "08df4e693fef2f85849caacefcb75783d5638b464f12480d274b3550375246bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "368803e0ea776f3f3faaa8a15ec88075af2d71fb36848a4f0f60974e99379eb8"
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