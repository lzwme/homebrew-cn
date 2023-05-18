class Libgr < Formula
  desc "GR framework: a graphics library for visualisation applications"
  homepage "https://gr-framework.org/"
  url "https://ghproxy.com/https://github.com/sciapp/gr/archive/refs/tags/v0.72.5.tar.gz"
  sha256 "0f9f71fae4ebd42bd267251f7db977f853bc5442ef9577d3c744da5a8403d6af"
  license "MIT"

  bottle do
    sha256 arm64_ventura:  "501a9d1a513a6e29647acbbcff823496e6f6c0c5f2ee2b4a7bfc426debb12625"
    sha256 arm64_monterey: "1e79ae14786567e28aaaac833735414fab50ddeffbb7df3b9c00519c87a1ed25"
    sha256 arm64_big_sur:  "7316148758745aef7b29aca3da6b663761e7dc0ca97927e3f18c2e5ea0ccaa2a"
    sha256 ventura:        "66c4e9a81d528233eaf82cc1fdfcbf3f4624b8cddcebd5647c7e90f1f21e8fb8"
    sha256 monterey:       "444d3414fc45788471790902f584cc4d64b2bb2ffb4be54288a9bbe0ace0f3a1"
    sha256 big_sur:        "52c3de711474733fec0e92bb6b07120468f99a7073cecda0c930d688936747d9"
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