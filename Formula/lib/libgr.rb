class Libgr < Formula
  desc "GR framework: a graphics library for visualisation applications"
  homepage "https://gr-framework.org/"
  url "https://ghfast.top/https://github.com/sciapp/gr/archive/refs/tags/v0.73.22.tar.gz"
  sha256 "528872d82f313517b80ac9233300f6fa9a3083f98ef25585f77260e8985b8263"
  license "MIT"

  bottle do
    sha256 arm64_tahoe:   "85b081742b70d8f9d5a386419678cbbfa1c2acf537421c5ac5cda79427c56497"
    sha256 arm64_sequoia: "cfce776a1fa94b9e3562c940cf7d6fa6209a50e57f99f4a7dc5dc3d290014ebc"
    sha256 arm64_sonoma:  "a26d35055f23d1a38f638a57a737206bf8b0fd9a3f772f2a81815862e21c7bac"
    sha256 sonoma:        "471139272541ade0255a18423d57a8bc094e962c62fd751c76503f77eef7d481"
    sha256 arm64_linux:   "26746198cf92945b7dbd2100d02543ef90f5261f21fed37d5ef46033b8474bd4"
    sha256 x86_64_linux:  "c3823b892c93e98765afff93df8ead2bb6dbff0daddd74de17205caae376af69"
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