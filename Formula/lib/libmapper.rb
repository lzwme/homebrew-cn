class Libmapper < Formula
  desc "Distributed system for media control mapping"
  homepage "http:www.libmapper.org"
  url "https:github.comlibmapperlibmapperreleasesdownload2.4.11libmapper-2.4.11.tar.gz"
  sha256 "971d878b650e5e28e44da2efa6499d92bb59566bca37e0a7185c958dd9bf5a12"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "7e20b3af4bfdf883c626c4fde810c56d77c9de10a974f3c57394a28d1ed13b5a"
    sha256 cellar: :any,                 arm64_sonoma:   "f4a60349593e99bb9249ad1c9640186075c8f126001a7ec63021565587ce6d35"
    sha256 cellar: :any,                 arm64_ventura:  "83196e9ca758e2da2ea5596f91b38f2f846e6112b71575d3c37bcd99af56b6d4"
    sha256 cellar: :any,                 arm64_monterey: "f6a3c68d2e5cbdef068dc3b95bab41dbb79b39f45f8f8c7cc27bf019998fcec1"
    sha256 cellar: :any,                 sonoma:         "a6e66887a17dd8ebc24438c56d560f47cf56cba29d1409519538374fd8ea164f"
    sha256 cellar: :any,                 ventura:        "4f372bfd201818a54711e91d5f96bd5ca046e5a92d0c0a03ef437eef789097ef"
    sha256 cellar: :any,                 monterey:       "7d706d4b197f0ddbf78d45f7b1373265dd0369dc9a11f9721cb7c60df3cab1a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2e2655c2bd994b1a03e9c9e75135047432036cc62011c96834e935f25fb66491"
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