class Libmapper < Formula
  desc "Distributed system for media control mapping"
  homepage "http:www.libmapper.org"
  url "https:github.comlibmapperlibmapperreleasesdownload2.4.5libmapper-2.4.5.tar.gz"
  sha256 "08d4568b7586379373f8e4d85332dd63a97c7f8b45702d5fc178614679f401bc"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "5bc25f5e9f330f027d84dbe6b23b6bd3fef6e64df4c70abbef1686acacea5c3b"
    sha256 cellar: :any,                 arm64_ventura:  "a0c01e7d0ece044ec483a160119f4095b317d1b684534ea09df3d8fe39a3209d"
    sha256 cellar: :any,                 arm64_monterey: "10b41299b9aa1989465d1af69e5ce6aded72d6ec594323fd5f963cd977465020"
    sha256 cellar: :any,                 sonoma:         "7b088ab4c831b1f588dddfd2e8210bc0f4f6be2868ac1b6f154ca9330c2c3f4a"
    sha256 cellar: :any,                 ventura:        "3722bef40f1a9e8e7cb8ed5494a3644f743ef2761e3b73956c737b1c2eb978a3"
    sha256 cellar: :any,                 monterey:       "c97852aa351d76867045d479c3eadb2c1aaba2a49e724e0e617eb9879e7061c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bd93b5ffcbf5650b394860b56d368e6a01267794032594760e8d49806ff3ac33"
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