class Libgr < Formula
  desc "GR framework: a graphics library for visualisation applications"
  homepage "https://gr-framework.org/"
  url "https://ghfast.top/https://github.com/sciapp/gr/archive/refs/tags/v0.73.27.tar.gz"
  sha256 "970cec765c4ef655b428d8af563edfadf21b733aa0530cf7e90ed18b913ee7b0"
  license "MIT"

  bottle do
    sha256 arm64_tahoe:   "8c0ac01aebbcae1f6b8060e753e1045cb29265e58d4455d32467f39fd39a9554"
    sha256 arm64_sequoia: "7cdcbe82efa0bcec2651d1e3037ef6619747d921f04823831e90415fa643a72f"
    sha256 arm64_sonoma:  "a0f2107330148a7999098e58b8c2d7adef934b9e8de2511edbe2f7592c6aafbc"
    sha256 sonoma:        "86544e72a5ef6edd05cfa1da91fb8e7eabbc8c712d2f4979930cc9e76024832d"
    sha256 arm64_linux:   "b9e9c85bde0859c553504ebb2798d7c5603265c98d648183dc195e8345365c2a"
    sha256 x86_64_linux:  "acfae23f4f9fd49b358212855cd7ae4af44f5f4609665ec73524f8fc1f0fc9ae"
  end

  depends_on "cmake" => :build
  depends_on "cairo"
  depends_on "ffmpeg"
  depends_on "freetype"
  depends_on "glfw"
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "pixman"
  depends_on "qhull"
  depends_on "qtbase"
  depends_on "zeromq"

  on_linux do
    depends_on "libx11"
    depends_on "libxt"
    depends_on "mesa"
    depends_on "zlib-ng-compat"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", "-DGR_PREFER_XCODEBUILD=OFF",
                                              "-DCMAKE_INSTALL_RPATH=#{rpath}",
                                              *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <stdio.h>
      #include <gr.h>

      int main(void) {
          gr_opengks();
          gr_openws(1, "test.png", 140);
          gr_activatews(1);
          double x[] = {0, 0.2, 0.4, 0.6, 0.8, 1.0};
          double y[] = {0.3, 0.5, 0.4, 0.2, 0.6, 0.7};
          gr_polyline(6, x, y);
          gr_axes(gr_tick(0, 1), gr_tick(0, 1), 0, 0, 1, 1, -0.01);
          gr_updatews();
          gr_emergencyclosegks();
          return 0;
      }
    C

    system ENV.cc, "test.c", "-o", "test", "-I#{include}", "-L#{lib}", "-lGR"
    system "./test"

    assert_path_exists testpath/"test.png"
  end
end