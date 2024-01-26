class Libgr < Formula
  desc "GR framework: a graphics library for visualisation applications"
  homepage "https:gr-framework.org"
  url "https:github.comsciappgrarchiverefstagsv0.73.1.tar.gz"
  sha256 "7f7eb3d409b617d843491f115243503506f62af1e5b701de40a0d715aeb5bfcf"
  license "MIT"

  bottle do
    sha256 arm64_sonoma:   "1994ce35e2fa324eae1d4ff0b5795424ba1602ece8e81915a4552964e527b735"
    sha256 arm64_ventura:  "396979587f7ea85d56d332a55f0f870e01fcc6120dd47c18f004d323556928db"
    sha256 arm64_monterey: "359c3386d43e6482e9ca648ce0ba3ffaa4acf0e42070b8b1feec3857942e1629"
    sha256 sonoma:         "8b609045970d50735dbf14f42526726b505684cba722c76cc979b0ba3a150a3c"
    sha256 ventura:        "3d9db081118ca44f1655a354a5af94791089d8f54b2a5cb8a931e8f485c35db7"
    sha256 monterey:       "785063a0bd368ab7d3b0e59ecfe8493176f240b41d37f93a9c6c2b2aaa2cdbcb"
    sha256 x86_64_linux:   "ffd2fe2375bc3779410d3d73f1b261d732e2cacaa4fe069cf99e5c112d081f7f"
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
    (testpath"test.c").write <<~EOS
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
    system ".test"

    assert_predicate testpath"test.png", :exist?
  end
end