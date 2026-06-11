class LibayatanaAppindicator < Formula
  desc "Ayatana Application Indicators Shared Library"
  homepage "https://github.com/AyatanaIndicators/libayatana-appindicator"
  url "https://ghfast.top/https://github.com/AyatanaIndicators/libayatana-appindicator/archive/refs/tags/0.6.0.tar.gz"
  sha256 "23be92ad8eb9625ce93b23b14f82f3cf88a4970c31d48581945ddfbac0441d06"
  license any_of: ["GPL-3.0-or-later", "LGPL-2.1-or-later"]

  bottle do
    sha256 cellar: :any, arm64_linux:  "13bd14ba25b3593099af562a4b0ef90bc9b87557498af47bf604a00976a0b19f"
    sha256 cellar: :any, x86_64_linux: "80c2e02be8fe93584887da8f49a0220fc55ef1f8e4bf0f87cd0d6f09580f4c13"
  end

  depends_on "at-spi2-core" => :build
  depends_on "cmake" => :build
  depends_on "gobject-introspection" => :build
  depends_on "intltool" => :build
  depends_on "libxml2" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "vala" => :build
  depends_on "ayatana-ido"
  depends_on "cairo"
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "gtk+3"
  depends_on "harfbuzz"
  depends_on "libayatana-indicator"
  depends_on "libdbusmenu"
  depends_on :linux # libayatana-indicator requires gio/gdesktopappinfo.h which is not available on macOS
  depends_on "pango"

  def install
    args = %w[
      -DENABLE_BINDINGS_MONO=OFF
      -DENABLE_BINDINGS_VALA=ON
      -DENABLE_GTKDOC=OFF
      -DENABLE_TESTS=OFF
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <libayatana-appindicator/app-indicator.h>
      #include <assert.h>

      int main() {
        AppIndicator *indicator = app_indicator_new("test-id", "test-icon", APP_INDICATOR_CATEGORY_APPLICATION_STATUS);
        assert(indicator != NULL);
        g_object_unref(indicator);
        return 0;
      }
    C

    flags = shell_output("pkgconf --cflags --libs ayatana-appindicator3-0.1").chomp.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end