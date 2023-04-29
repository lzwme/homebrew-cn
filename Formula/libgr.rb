class Libgr < Formula
  desc "GR framework: a graphics library for visualisation applications"
  homepage "https://gr-framework.org/"
  url "https://ghproxy.com/https://github.com/sciapp/gr/archive/refs/tags/v0.72.3.tar.gz"
  sha256 "95430ad32a31dd9710d06856d3d68cb3efe7aad608a67037962d0a6ef17a8fd2"
  license "MIT"

  bottle do
    sha256 arm64_ventura:  "beb1e37eca06e1aa91f2feb3efc653d8f5a14d63f0d1df19d251f9be43cbd4e5"
    sha256 arm64_monterey: "391020e71b77b6d9bbe8f1dbb34a0fd17d3537e628cd4d760243be763cc7de14"
    sha256 arm64_big_sur:  "bfa69c3ae442bcd2eae1cfa655f21708ec5fcd16dec3998d75c0128ef9922caa"
    sha256 ventura:        "70b97a39899a7956074cafd0eaafa4372c0edd68a3142e2536edf0b7ccbde510"
    sha256 monterey:       "e452e08493d798bebe8364c61afa897a28a76bf9b009791551107e0dd7bdf5e1"
    sha256 big_sur:        "1b7a7fcb83d58e50816bca7e22183410257720cd2f76a693a66208ff57761e9c"
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