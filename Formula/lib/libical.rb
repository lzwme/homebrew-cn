class Libical < Formula
  desc "Implementation of iCalendar protocols and data formats"
  homepage "https://libical.github.io/libical/"
  url "https://ghfast.top/https://github.com/libical/libical/releases/download/v4.0.6/libical-4.0.6.tar.gz"
  sha256 "2e3729cb69c282d3bb17a8d2b198af6e4bc7502fd3621c9adf573921fe9dceb0"
  license any_of: ["LGPL-2.1-or-later", "MPL-2.0"]
  compatibility_version 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "43407333cb5755e06332bb6802e6bf6d596db041665137cf091dd945decb8c56"
    sha256 cellar: :any, arm64_tahoe:       "6e2dc1199f3e3f78e93bb8173f6f55db09b3ae38dabc6c50bf3ccd66261252fb"
    sha256 cellar: :any, arm64_sequoia:     "288b7c51c2daa1768e7996fc82bf83b5cc5e6fe1f2a27c08619ede4b774d09a2"
    sha256 cellar: :any, arm64_linux:       "83959a77cc5a9dd361af6195f0e56f6f272736bc071ea782ffb8f9811c119091"
    sha256 cellar: :any, x86_64_linux:      "aa6ad757af943637db8ab69d61032b284a77f0f390def5abeb6e559279f3563b"
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

  deny_network_access!

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