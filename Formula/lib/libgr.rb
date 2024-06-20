class Libgr < Formula
  desc "GR framework: a graphics library for visualisation applications"
  homepage "https:gr-framework.org"
  url "https:github.comsciappgrarchiverefstagsv0.73.6.tar.gz"
  sha256 "00f6265e8d7c27a74a7a717006e7f18d4193748e1a36ca5d3f6749b5dd48dc09"
  license "MIT"

  bottle do
    sha256 arm64_sonoma:   "4c22d40e0f3e5fb0571d5ff87dee56a64dc34b4670d3f488813b5068d91c2896"
    sha256 arm64_ventura:  "704cbaa41f7a660ea98424f2c76fc691acfc4ed78c1853db9fa5dfecd8e2b957"
    sha256 arm64_monterey: "28b481d782e3f2c04497df7e7c7c66698c0b44818bccaaf571fa7c8169a7bcfd"
    sha256 sonoma:         "30998f6669c1b44db819e82a3158f48c9b4a91da0f1db5463736918bef278538"
    sha256 ventura:        "6b82df8b7eb80400d56931a88b51d40debbd46765449d53daa8165eef67063e2"
    sha256 monterey:       "9aeaf67006a567d70739884c8befec0ed6ec68cfed1b1a09f901a6d62face91d"
    sha256 x86_64_linux:   "434265f56a364a14daff6c3635baea530d4290c8057c29f46d83e1b02d5ddc39"
  end

  depends_on "cmake" => :build
  depends_on "cairo"
  depends_on "ffmpeg@6"
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