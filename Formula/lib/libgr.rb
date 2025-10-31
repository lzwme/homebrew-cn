class Libgr < Formula
  desc "GR framework: a graphics library for visualisation applications"
  homepage "https://gr-framework.org/"
  url "https://ghfast.top/https://github.com/sciapp/gr/archive/refs/tags/v0.73.18.tar.gz"
  sha256 "0821ce71be438b09fdf4a62c567197ce5b35a0ab1e9c925d2817f0ff1ff67294"
  license "MIT"

  bottle do
    sha256 arm64_tahoe:   "91a3bbb4f0d1daaf6f369ae6f589b602fa9ea5e9cc2c2922e3e0971cc2e23654"
    sha256 arm64_sequoia: "2a71eacc11e748f7f7bf52d77618a8638a9c2d31a662de5d201ecbc637a49a25"
    sha256 arm64_sonoma:  "34f575ce2384b823069fb21ee88c8f7fc169d66250db442c3f6f0ce790d646fa"
    sha256 sonoma:        "3a705923ee7a261a6c1ef501a2457fcec55fc5c2257a85f6d3971232f7f16143"
    sha256 arm64_linux:   "59a174b4ad51069bdfac5b9a43e8b43e2d7cde29209413091dcf82f37fcef1ea"
    sha256 x86_64_linux:  "e6802acbecfdb37466ccc4f71fa5539a1b848b267871bed74ef3bd40bfdb538e"
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