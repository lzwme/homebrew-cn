class Libgr < Formula
  desc "GR framework: a graphics library for visualisation applications"
  homepage "https://gr-framework.org/"
  url "https://ghproxy.com/https://github.com/sciapp/gr/archive/refs/tags/v0.72.2.tar.gz"
  sha256 "03cc08779e1b06a885c9b6fa45954ec50e3b45dd94067c46a462bf66138eb566"
  license "MIT"

  bottle do
    sha256 arm64_ventura:  "ac7a688b05410c7ac6fb0fbf1a68a91e63a8a803fb422f351265cf6ef1bf143c"
    sha256 arm64_monterey: "ba62196191a9ae98d48f53f5a63b9b557fed4a7f2ce05ebf85ac51ebe63fe6f8"
    sha256 arm64_big_sur:  "f974aa024c193d0357ce2e71c7bf2df9080e7dab377433356b72bfd7e0c86162"
    sha256 ventura:        "fafd9da147c6321f63208be57eb0da86c7e7446d42c143e394919e92792097c3"
    sha256 monterey:       "77ae90ad5139ff1817cbf9a6e705c8e6f51ab9d7b6447d45f1450319a53dcc49"
    sha256 big_sur:        "b6edc7523fe9036828b31b54e4d99edda79a55aeb5802c1b978a032b76f7e773"
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