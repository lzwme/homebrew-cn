class Libical < Formula
  desc "Implementation of iCalendar protocols and data formats"
  homepage "https://libical.github.io/libical/"
  url "https://ghfast.top/https://github.com/libical/libical/releases/download/v4.0.4/libical-4.0.4.tar.gz"
  sha256 "c851cdb46da5e6397881dafaa592c5516fb49da05dd1bb095f711a6d20eac422"
  license any_of: ["LGPL-2.1-or-later", "MPL-2.0"]
  compatibility_version 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "185d8edd4a5f7d4dbfd3d8844d7e973ed5034c0100c8888898f952886daf1eb2"
    sha256 cellar: :any, arm64_sequoia: "e9268082dd51e9db25864b2033071fd5024254561c7888d2382f704102af07da"
    sha256 cellar: :any, arm64_sonoma:  "288d4eea1bee1e4790c822764618fbedbbf8e7a0b4add78036f2e93f2d940836"
    sha256 cellar: :any, sonoma:        "a4786ad0db88646e1d7699f4687304641b2a7a92bb9633b39a0214233b2407e0"
    sha256 cellar: :any, arm64_linux:   "5435b57a3f9cb810883a0143fd89d2ea0eecca0f08f0193200b83a17e4d8cf6e"
    sha256 cellar: :any, x86_64_linux:  "8ffe7ba5c510dad4c4bf0609c6944ab2694b834a92695308175924db26484415"
  end

  depends_on "cmake" => :build
  depends_on "gobject-introspection" => :build
  depends_on "pkgconf" => :build
  depends_on "glib"
  depends_on "icu4c@78"

  uses_from_macos "libxml2"

  on_macos do
    depends_on "gettext"
  end

  def install
    args = %W[
      -DCMAKE_DISABLE_FIND_PACKAGE_BerkeleyDB=ON
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DLIBICAL_GLIB_BUILD_DOCS=OFF
      -DLIBICAL_JAVA_BINDINGS=OFF
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #define LIBICAL_GLIB_UNSTABLE_API 1
      #include <libical-glib/libical-glib.h>
      int main(int argc, char *argv[]) {
        ICalParser *parser = i_cal_parser_new();
        return 0;
      }
    C

    system ENV.cc, "test.c", "-o", "test", "-L#{lib}", "-lical-glib",
                   "-I#{formula_opt_include("glib")}/glib-2.0",
                   "-I#{formula_opt_lib("glib")}/glib-2.0/include"
    system "./test"
  end
end