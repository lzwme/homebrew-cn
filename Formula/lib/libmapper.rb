class Libmapper < Formula
  desc "Distributed system for media control mapping"
  homepage "http:www.libmapper.org"
  url "https:github.comlibmapperlibmapperreleasesdownload2.4.8libmapper-2.4.8.tar.gz"
  sha256 "f693e9ec36fc4836710979e84cf7e02aefbda4af1a17cd401428b5d028957359"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "81b47b0e2cbfb67e056a2121ae66b3cb79689b1ea99a9a0201d1be1687d190b8"
    sha256 cellar: :any,                 arm64_ventura:  "486a786b8303d2978fdccba302e7cee8430c9ca986314b3eace32fe1bffd9574"
    sha256 cellar: :any,                 arm64_monterey: "5c8cd6c21ddb4bad018ee01d1e91bb543b7372caba8ccd410e2d4fc6ff1d4959"
    sha256 cellar: :any,                 sonoma:         "ca0cbf97ec05f8d6a24170d4f80938b03d4fc728e091d08989ad1bc009bee5ff"
    sha256 cellar: :any,                 ventura:        "93ffca45e31a2f4b099e51a4f7ab6d60898b6142106181ddb7402e29aca7221d"
    sha256 cellar: :any,                 monterey:       "c688da82378745e3f87ecb7a8093ac489b374ee0afbf37d25af6d0f1f9515d36"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "49b3ce992216bdbdea511dc8bc3a833dbe951a82bb65780a133091244bb51462"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "liblo"

  uses_from_macos "zlib"

  def install
    system ".configure", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath"test.c").write <<~EOS
      #include <stdio.h>
      #include "mappermapper.h"
      int main() {
        printf("%s", mpr_get_version());
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lmapper", "-o", "test"
    assert_match version.to_s, shell_output(".test")
  end
end