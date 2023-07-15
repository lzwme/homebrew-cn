class Libgr < Formula
  desc "GR framework: a graphics library for visualisation applications"
  homepage "https://gr-framework.org/"
  url "https://ghproxy.com/https://github.com/sciapp/gr/archive/refs/tags/v0.72.8.tar.gz"
  sha256 "e1228da75047b849288c72b27a0fbafc1ae101edd0679046da36012879c1622a"
  license "MIT"

  bottle do
    sha256 arm64_ventura:  "113ee4fabf69cc0bcd54f78054908b0fd0c275e261f9e5773cd499889d73eff6"
    sha256 arm64_monterey: "b765b56473a665bccf496333900526edc8713eeff1856a053669d42b3295183c"
    sha256 arm64_big_sur:  "7a61faca36a0b8e5a6450460fca70df8ffdd427322bc489d50ba8fdc19e159a7"
    sha256 ventura:        "6b86e8179890c6d8cbbcc2c1d11d373909d55198d31a2ed529110446285843e9"
    sha256 monterey:       "67d90e273fe6a5c8af3db54a07aa335ca58e275bcff9a1bdc09a73f66faa1618"
    sha256 big_sur:        "0e444fdfd6fcfbefe296d1e401b2a4ee6759d1b34ef0db11462c2722b26fb312"
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