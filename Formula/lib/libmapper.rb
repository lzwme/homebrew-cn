class Libmapper < Formula
  desc "Distributed system for media control mapping"
  homepage "http://www.libmapper.org"
  url "https://ghfast.top/https://github.com/libmapper/libmapper/releases/download/2.5/libmapper-2.5.tar.gz"
  sha256 "3fc01ecc6b6ced848e4799d9470734d4c28a005c62577ebb40cd3d960d68309e"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "206212b43c24c03bfd04dd3332512d634f4d59a89a636677491eaf5de0a3dcbc"
    sha256 cellar: :any,                 arm64_sequoia: "564cccb42c9561341f6b17aa6a5d36d0496523842cd51d6ab2e35ede1aae69f8"
    sha256 cellar: :any,                 arm64_sonoma:  "34af9129d01601a8aa36a6652f2dac3c5bccc6d3f7a24c75aac5d5792719193a"
    sha256 cellar: :any,                 sonoma:        "c878d066555242d53b770d251fe676b4414aa94c57a16f77ebff8d435edc60c1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c96c6094dfeb3183c0d3941ba13b15865586897603313c1725c8e4fa3381a9f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ca2f98924474b856fdab3fc82657debfe6bb3896268c805e114603fc37fdb5d8"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "liblo"

  uses_from_macos "zlib"

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <stdio.h>
      #include "mapper/mapper.h"
      int main() {
        printf("%s", mpr_get_version());
        return 0;
      }
    C
    system ENV.cc, "test.c", "-L#{lib}", "-lmapper", "-o", "test"
    assert_match version.to_s, shell_output("./test")
  end
end