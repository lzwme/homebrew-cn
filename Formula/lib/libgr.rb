class Libgr < Formula
  desc "GR framework: a graphics library for visualisation applications"
  homepage "https://gr-framework.org/"
  url "https://ghfast.top/https://github.com/sciapp/gr/archive/refs/tags/v0.73.17.tar.gz"
  sha256 "dafd6ee72d36226d4664ca32d85d0b68224d5dba710abb8a4578c427259858e1"
  license "MIT"
  revision 1

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "c419f470192d46b07acfdea62b272b63c7c558e304c2d5eec554a94a8d3a32c4"
    sha256 arm64_sequoia: "e3d7abf46e0cd291f2eeea2b18e121f12b421b89bdb8e499676268344fc91464"
    sha256 arm64_sonoma:  "ea87941cd1713773c4f5ef128fce8f25c6d6ba42a08b2b972b287a14f5ff61e7"
    sha256 sonoma:        "4c89da88dd44c40f50933c68bbe381fc684b13b55832a9e3a02d5c527650b6ae"
    sha256 x86_64_linux:  "0fbd45d4ee1913cd8041d17448ae2b72dcab0fb692604e46f4e02f3a80818128"
  end

  depends_on "cmake" => :build
  depends_on "cairo"
  depends_on "ffmpeg@7" # FFmpeg 8 issue: https://github.com/sciapp/gr/issues/197
  depends_on "freetype"
  depends_on "glfw"
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "pixman"
  depends_on "qhull"
  depends_on "qtbase"
  depends_on "zeromq"

  uses_from_macos "zlib"

  on_linux do
    depends_on "libx11"
    depends_on "libxt"
    depends_on "mesa"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
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