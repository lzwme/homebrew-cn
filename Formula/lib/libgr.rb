class Libgr < Formula
  desc "GR framework: a graphics library for visualisation applications"
  homepage "https://gr-framework.org/"
  url "https://ghfast.top/https://github.com/sciapp/gr/archive/refs/tags/v0.73.26.tar.gz"
  sha256 "6dfe5bbd0c321d0714f391ad2e65b983fc0c34f518df773f7c7fa18545fd0fb5"
  license "MIT"

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "a0a40ac3003f214395ec8f74665c39f0b11255423741841dd1a03e29e63c770a"
    sha256 arm64_sequoia: "e98facddb85efc8b70b920c33f60a6434cff95157d955c383b69b7874535a488"
    sha256 arm64_sonoma:  "5f25340467060f37087bd15fc476a2bd6bec82b630337c6fcd8a2ffe176a901f"
    sha256 sonoma:        "6abaaf907ae7b63402fe855738a31c26281a4828475e0eecd9fed57df1b8a4b7"
    sha256 arm64_linux:   "50cb0dc26f7f409922ade13d5dd36093f05bfb19b6cf7c9f9b60f82cde8e2667"
    sha256 x86_64_linux:  "a60298a5a1f4c1040a88655ffd33a1b258c68d2eba984759a93a5cd1f32baa8a"
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