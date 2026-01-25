class Libgr < Formula
  desc "GR framework: a graphics library for visualisation applications"
  homepage "https://gr-framework.org/"
  url "https://ghfast.top/https://github.com/sciapp/gr/archive/refs/tags/v0.73.21.tar.gz"
  sha256 "ccc5a67f0e7116f65249d0bb5171fb09f9aa4f1e5133db355b4c77490e3c6170"
  license "MIT"

  bottle do
    sha256 arm64_tahoe:   "1d4b4728af2b5f17cd9f83d8df1db16f38aa39a9bf135b5b02f581f8d6e95251"
    sha256 arm64_sequoia: "abcfc2b0b0923598ca823578a9c9b3a440ccee39ade170e1f38042ae4cc0841e"
    sha256 arm64_sonoma:  "48947904bd84057fb13fd0cf9ed644ab85b40245b8509e940d665b42baeae1fb"
    sha256 sonoma:        "2de1e646866f9a50dcea4f1e31b829f4366e4b8ceabf3c6c76a180e9109d1b3b"
    sha256 arm64_linux:   "4833973e09a3743f45721254533545606e882fdce84d10c35c7ad0b2622f264b"
    sha256 x86_64_linux:  "923b1972117b14a69de24251ca3cfd9ff625c2dbf5550cc2f143fab44245ed68"
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