class Libgr < Formula
  desc "GR framework: a graphics library for visualisation applications"
  homepage "https:gr-framework.org"
  url "https:github.comsciappgrarchiverefstagsv0.73.9.tar.gz"
  sha256 "b784300c069582cb30b45233f358dfcde176fec53250f0bb5d93e0e21c0f1a1f"
  license "MIT"

  bottle do
    sha256 arm64_sonoma:  "bc68059bba097861d2abdb86ccf884c8da6fd75e0cf2038a8c0db9ea360d0aa7"
    sha256 arm64_ventura: "37e5188036fefbec7c4d3110177b64c3b5f475811e176c2ba926b72fb57eb0c3"
    sha256 sonoma:        "459e35eab2e559cfbbee8923bb1af63561f23dce0bc89b233136a0c22b58f17d"
    sha256 ventura:       "073389373df87e0282d1395b82efbeb085aef812bbb0d279c0279ee82b86b18d"
    sha256 x86_64_linux:  "c18b1bdd6e3d7ff848e32347e75542a481615e42da06ff2bd234ad294dcc4a0a"
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
  depends_on "qt"
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
    (testpath"test.c").write <<~C
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
    system ".test"

    assert_predicate testpath"test.png", :exist?
  end
end