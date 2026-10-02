class LibimobiledeviceGlue < Formula
  desc "Library with common system API code for libimobiledevice projects"
  homepage "https://libimobiledevice.org/"
  url "https://ghfast.top/https://github.com/libimobiledevice/libimobiledevice-glue/releases/download/1.3.2/libimobiledevice-glue-1.3.2.tar.bz2"
  sha256 "6489a3411b874ecd81c87815d863603f518b264a976319725e0ed59935546774"
  license "LGPL-2.1-or-later"
  revision 1
  compatibility_version 1
  head "https://github.com/libimobiledevice/libimobiledevice-glue.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "c67072788122860a4c2b7987f7d031199f3ddf85569eb96767c89a434f8e53d6"
    sha256 cellar: :any, arm64_tahoe:       "8ba3edbfc9c9c50cd340f1d836a047bbc92f280ce0af88b76a77e501df367db2"
    sha256 cellar: :any, arm64_sequoia:     "691e69439ca8c9954fc87cc709b6711e2cb2b8b3aa7ba430a63b378930fb623e"
    sha256 cellar: :any, arm64_linux:       "5aed697d210d268f0723f41de1ae12d0559bee5175a4b30daef30034b1466035"
    sha256 cellar: :any, x86_64_linux:      "b5560685c2c3f045c10588e02ffe91f43f3fa52d05704c54d01dc022bb92886f"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "libplist"

  def install
    configure = build.head? ? "./autogen.sh" : "./configure"
    system configure, "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include "libimobiledevice-glue/utils.h"

      int main(int argc, char* argv[]) {
        char *uuid = generate_uuid();
        return 0;
      }
    C
    system ENV.cc, "test.c", "-L#{lib}", "-limobiledevice-glue-1.0", "-o", "test"
    system "./test"
  end
end