class Libgr < Formula
  desc "GR framework: a graphics library for visualisation applications"
  homepage "https://gr-framework.org/"
  url "https://ghfast.top/https://github.com/sciapp/gr/archive/refs/tags/v0.73.17.tar.gz"
  sha256 "dafd6ee72d36226d4664ca32d85d0b68224d5dba710abb8a4578c427259858e1"
  license "MIT"
  revision 1

  bottle do
    rebuild 2
    sha256 arm64_tahoe:   "7bdc851e189cd0e32c3ebc1dd760629341245ee35b0047ccc25dc4ef0e749c11"
    sha256 arm64_sequoia: "6e72a7cf25de633dd8b2bedd6093e3b30d46fc546d2e0a9bcab3779654f5801c"
    sha256 arm64_sonoma:  "4ebac584fca59929884fe517b5adfa363e21d82d527b0f345d77f5fc6510471c"
    sha256 sonoma:        "d471b8b3d4f3b1acba6f0d9f2f9ef80a71ba00fd645cb8371838895d8d25308a"
    sha256 arm64_linux:   "de47454028332641b07160f75edb27e6ffdc2c14986e53744db8c03110877121"
    sha256 x86_64_linux:  "ebec641dff0e1f8389ea8cc04a1b1585c50da5f2b4bdbce63efc6ea738ee9c91"
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

  # Backport support for FFmpeg 8
  patch do
    url "https://github.com/sciapp/gr/commit/1720943f5ecf76b067dc2950fab2d381378aaf18.patch?full_index=1"
    sha256 "b1b453e5a6aa878d0bea159f777e445dc4a73ba619d1672818341746b1b4e861"
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