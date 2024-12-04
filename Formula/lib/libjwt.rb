class Libjwt < Formula
  desc "JSON Web Token C library"
  homepage "https:github.combenmcollinslibjwt"
  url "https:github.combenmcollinslibjwtreleasesdownloadv1.18.3libjwt-1.18.3.tar.bz2"
  sha256 "7c582667fe3e6751897c8d9c1b4c8c117bbfa9067d8398524adb5dded671213e"
  license "MPL-2.0"
  head "https:github.combenmcollinslibjwt.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "6700895a78f1c621f84a1576ea50bae94f6598a2baa397d1ee89073cd2163b97"
    sha256 cellar: :any,                 arm64_sonoma:  "9afe31b8a4ee67fcf2e48199e61993f070dba5ce22a9bca5dbe69eca372a5b18"
    sha256 cellar: :any,                 arm64_ventura: "e13eabbc661d4a668b920078e86b87e695517ed22b6b7c8a9741cf1e1075c796"
    sha256 cellar: :any,                 sonoma:        "d24d2c62e66928b6b151ce7954a7ea703cfe9d77d3c5ac66160099652b7b14d9"
    sha256 cellar: :any,                 ventura:       "69e40b90da45c93bf213616125e4deef6a451a904e5b19442b139ea1c714e378"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7c7023517f53333fe537cb82288e2f99fd61421d6df096e8f85d5b1801762ed8"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
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