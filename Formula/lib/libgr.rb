class Libgr < Formula
  desc "GR framework: a graphics library for visualisation applications"
  homepage "https://gr-framework.org/"
  url "https://ghfast.top/https://github.com/sciapp/gr/archive/refs/tags/v0.73.23.tar.gz"
  sha256 "aa70d039a4c699ba717c0cd2abd7de990923019d381a8a157b9dab1d52301262"
  license "MIT"

  bottle do
    sha256 arm64_tahoe:   "5dd17313adf60cc2b6fad3f79f9ba9549e23834a20f650879d068157e83b7149"
    sha256 arm64_sequoia: "28acba9155a4f12bc810844ce560fb41a9803a130f2fe3127f0d12d18ddd1d56"
    sha256 arm64_sonoma:  "014fed1d1f242fa597bda024ca958a2985ba8efe16d503ae106d0307bcb2dfe5"
    sha256 sonoma:        "f47db50755138414bcd7970c404eef0505644b523c0743284013e43141a3379c"
    sha256 arm64_linux:   "690437c7549d5d7e887603df051109a706155d5dc2856d83363084684c881742"
    sha256 x86_64_linux:  "7bdebb3b48e94e6af818ff9ff7857af02d4ee67816fd7e5a3f6ee3ffbff796a3"
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