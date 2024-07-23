class Libgr < Formula
  desc "GR framework: a graphics library for visualisation applications"
  homepage "https:gr-framework.org"
  url "https:github.comsciappgrarchiverefstagsv0.73.7.tar.gz"
  sha256 "2584727b1413a337ef14daae1e61bdc5c946403031695b42ecfbf8bc1888d132"
  license "MIT"

  bottle do
    sha256 arm64_sonoma:   "151c2541f5465682ecdd5a69856463db37f684e3194f5c13d2aab97cb11c2919"
    sha256 arm64_ventura:  "1f1599f6a4b6abcf3a2d07e53a8a54de1407e8ef7c0dc1974622416d1ca5b912"
    sha256 arm64_monterey: "f33a6cb78447fc0e410470cb61f7c472e989198aa9e642d270f9d8e4d67e76f0"
    sha256 sonoma:         "b2e39f5e4bab5db900610fc2869c9e29b417b21df98b126883951136e5e69c91"
    sha256 ventura:        "ad82fc1fe1f247cfee54b577a55d61f52ab87f7eda2cc4aff446b14ea60731e3"
    sha256 monterey:       "8e8422424e63d968da5ecedcf38e218a8807a85ad68a88b850d06ff931da5428"
    sha256 x86_64_linux:   "5485d4f2faf12243a4c95e92c7f15e6d2a1e86c4657463dc6f230f164030a30a"
  end

  depends_on "cmake" => :build
  depends_on "cairo"
  depends_on "ffmpeg@6"
  depends_on "freetype"
  depends_on "glfw"
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "pixman"
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