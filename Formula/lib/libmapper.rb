class Libmapper < Formula
  desc "Distributed system for media control mapping"
  homepage "http://www.libmapper.org"
  url "https://ghproxy.com/https://github.com/libmapper/libmapper/releases/download/2.4.2/libmapper-2.4.2.tar.gz"
  sha256 "130d0761cd6006c2f7458771ae0484d53d601d85dba9315cdffd4da4c30bf86b"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "ea306668b0240c47d5fbc4da409dda8f4a8a1cded90de8226895fa990d6c064f"
    sha256 cellar: :any,                 arm64_monterey: "b9743ebdf0c9492894b22d116e21416283ade34fdecf5b2a3d68be08c116265c"
    sha256 cellar: :any,                 arm64_big_sur:  "e53548b90eaba32f33d881a87e8738f62d6311e920e1e24e1044926c91424312"
    sha256 cellar: :any,                 ventura:        "b868a59a5f1c3513f08fa18e2d319a4b925a3aad76b607e3ed608df61c092eff"
    sha256 cellar: :any,                 monterey:       "02abf80027d8834ba0ff8f7e02cf1b7d00d73e417ec6ea90ea657486b89b17bc"
    sha256 cellar: :any,                 big_sur:        "a405d611f9b6050b5918a32daad40d081aa557e99e8d3ec0166b154c86c8c15c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3b2077872b0e033064ad525842e7a992922e1280d493630b8764facb444fb64e"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "liblo"

  uses_from_macos "zlib"

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include "mapper/mapper.h"
      int main() {
        printf("%s", mpr_get_version());
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lmapper", "-o", "test"
    assert_match version.to_s, shell_output("./test")
  end
end