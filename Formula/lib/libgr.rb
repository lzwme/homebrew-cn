class Libgr < Formula
  desc "GR framework: a graphics library for visualisation applications"
  homepage "https://gr-framework.org/"
  url "https://ghproxy.com/https://github.com/sciapp/gr/archive/refs/tags/v0.72.11.tar.gz"
  sha256 "beb0f29480ab066905102295caf857a35d61fb269c5313a9f33efd71454f8a76"
  license "MIT"

  bottle do
    sha256 arm64_sonoma:   "b0fb19504f5430fb8f7a4088a0ebb7865103a19f0e09a0a99b8a24013135053e"
    sha256 arm64_ventura:  "db76725a3ed17052ee3bae6df9e95ba7dd44aca8e409e2101c0e14cfb703ce12"
    sha256 arm64_monterey: "f06a41ec3f14e6108bb07c4553f547d36b28811a50447281eeb8547b789c9c0b"
    sha256 sonoma:         "d6f145e77878dfb7403beb81926187269ae28224313db27c6581f4a1fd6eb245"
    sha256 ventura:        "b073c628fff98924c565b8e72be3e6ef3c3c83a679295a908a401a4f7ad508bd"
    sha256 monterey:       "ef7d69f87ec7a08f9fccf09ecc2cd9be4b3c827645362b83c8b54952e472a15f"
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