class Libgr < Formula
  desc "GR framework: a graphics library for visualisation applications"
  homepage "https://gr-framework.org/"
  url "https://ghfast.top/https://github.com/sciapp/gr/archive/refs/tags/v0.73.25.tar.gz"
  sha256 "972ff8d435a45165c690300527496d5e8866b72e35867cfb3edc1d8ee3081d5a"
  license "MIT"

  bottle do
    sha256 arm64_tahoe:   "a3250b543ba6562de322e4f27169cc519748c1d49eb370f45eeaec45db386daf"
    sha256 arm64_sequoia: "c1c080e39021940fc067dc1ba07dec85863e839ca75a08842d720838e3be153e"
    sha256 arm64_sonoma:  "554e6ad3c79ac7058d17d2da08da9ed99a53b23f8231fa4192ebbb65b4feb2d1"
    sha256 sonoma:        "c24f32d357cf8b5ef44b22ba5036533c2038466b6a52ff82a2c22c092cc01ef0"
    sha256 arm64_linux:   "b13c834560a4988086a33d9f7ee86581ce7e74fb6d35532cd179f0f67996ef3d"
    sha256 x86_64_linux:  "f4d4bb0e11ebb957930b04b1f88dd330d919bce13462839b8af478bc059734e3"
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
    system "cmake", "-S", ".", "-B", "build", "-DGR_PREFER_XCODEBUILD=OFF", *std_cmake_args
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