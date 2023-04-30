class Libgr < Formula
  desc "GR framework: a graphics library for visualisation applications"
  homepage "https://gr-framework.org/"
  url "https://ghproxy.com/https://github.com/sciapp/gr/archive/refs/tags/v0.72.4.tar.gz"
  sha256 "ac765a3144033d25fef7eb5b2a62e05c500da7dc07e1479af7c95340259251ec"
  license "MIT"

  bottle do
    sha256 arm64_ventura:  "9d8fd0f6b3378aeb85c5847e8314a4ff3ce76d2ffebc778766b5522fd55292f3"
    sha256 arm64_monterey: "d374fbd01dbb186fd9294273b76181c8c1cf042c6162dc1edc4598f7fae6d6a6"
    sha256 arm64_big_sur:  "bf82d69dd5f7dec3265d027d412c268cb8eb646d5e4c8b2e790fcded3838b19e"
    sha256 ventura:        "1779c198dc94c83135fc897cbe6bdc7cfad2a8bb8dc1e35cb557e92975170052"
    sha256 monterey:       "61c0eb74439ad6b57c114b6f5dcb8794085998526d556822bd97d337c22ed478"
    sha256 big_sur:        "fffc2d37f28a7b03bf6ecee4d95184a95fcf1b8abb7342750c95ace502de197b"
  end

  depends_on "cmake" => :build
  depends_on "cairo"
  depends_on "glfw"
  depends_on "libtiff"
  depends_on "qhull"
  depends_on "qt"
  depends_on "zeromq"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make"
      system "make", "install"
    end
  end

  test do
    (testpath/"test.c").write <<~EOS
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
    EOS

    system ENV.cc, "test.c", "-o", "test", "-I#{include}", "-L#{lib}", "-lGR"
    system "./test"

    assert_predicate testpath/"test.png", :exist?
  end
end