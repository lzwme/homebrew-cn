class LibayatanaIndicator < Formula
  desc "Ayatana Indicators Shared Library"
  homepage "https://github.com/AyatanaIndicators/libayatana-indicator"
  url "https://ghfast.top/https://github.com/AyatanaIndicators/libayatana-indicator/archive/refs/tags/0.9.5.tar.gz"
  sha256 "73d71c908b803f12e4a5ecd8392511b58afbdd0c82ad7909611a17bb7847c5c8"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_linux:  "6c85a40732344dd09a745df53a87af7e203eed256ca48d2190bbc02f912367bc"
    sha256 cellar: :any, x86_64_linux: "51b1d81aba0e7f193a4c424157fc86cf393fea36d884317eb97ed7c9291dbec7"
  end

  depends_on "cmake" => :build
  depends_on "gobject-introspection" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "vala" => :build
  depends_on "at-spi2-core"
  depends_on "ayatana-ido"
  depends_on "cairo"
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "gtk+3"
  depends_on "harfbuzz"
  depends_on :linux # PR ref: https://github.com/AyatanaIndicators/libayatana-indicator/pull/77
  depends_on "pango"

  def install
    args = %w[
      -DENABLE_IDO=ON
      -DENABLE_LOADER=ON
      -DENABLE_TESTS=OFF
      -DFLAVOUR_GTK3=ON
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <libayatana-indicator/indicator-service.h>
      #include <assert.h>
      int main() {
        IndicatorService *service = indicator_service_new("homebrew-test");
        assert(service != NULL && "indicator_service_new should not return NULL");
        g_object_unref(service);
        return 0;
      }
    C

    flags = shell_output("pkgconf --cflags --libs ayatana-indicator3-0.4").chomp.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end