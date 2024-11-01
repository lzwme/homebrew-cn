class Libical < Formula
  desc "Implementation of iCalendar protocols and data formats"
  homepage "https:libical.github.iolibical"
  url "https:github.comlibicallibicalreleasesdownloadv3.0.18libical-3.0.18.tar.gz"
  sha256 "72b7dc1a5937533aee5a2baefc990983b66b141dd80d43b51f80aced4aae219c"
  license any_of: ["LGPL-2.1-or-later", "MPL-2.0"]
  revision 2

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "12ed9bd20e48d2a2e2179ac13ac2a0680e230f977327131c47bc2496b10f9e9a"
    sha256 cellar: :any,                 arm64_sonoma:  "09ef21d33928ca0f752e03f9da8c553682539a4a54ecbf046c6355d31230e821"
    sha256 cellar: :any,                 arm64_ventura: "c8e2ac34b1c0ba410afeb4a5edb16746836c1479f80341a2bdec8b179baab4ea"
    sha256 cellar: :any,                 sonoma:        "15ef37cc1f62f61d674ab2641ca678d3ea355c95cfa97df05332bcb1f7140a4f"
    sha256 cellar: :any,                 ventura:       "9bb23e2c4724bff5b3446a47510e84f6f2acf4ae7fac74ab9c4119a3c48748f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "50bab3d317e999bbabf84081ba16a074703023ae3a28f2bf6510b6eb7a76cdfc"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "icu4c@76"

  uses_from_macos "libxml2"

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "berkeley-db@5"
  end

  def install
    system "cmake", ".", "-DBDB_LIBRARY=BDB_LIBRARY-NOTFOUND",
                         "-DENABLE_GTK_DOC=OFF",
                         "-DSHARED_ONLY=ON",
                         "-DCMAKE_INSTALL_RPATH=#{rpath}",
                         *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath"test.c").write <<~C
      #define LIBICAL_GLIB_UNSTABLE_API 1
      #include <libical-gliblibical-glib.h>
      int main(int argc, char *argv[]) {
        ICalParser *parser = i_cal_parser_new();
        return 0;
      }
    C
    system ENV.cc, "test.c", "-o", "test", "-L#{lib}", "-lical-glib",
                   "-I#{Formula["glib"].opt_include}glib-2.0",
                   "-I#{Formula["glib"].opt_lib}glib-2.0include"
    system ".test"
  end
end