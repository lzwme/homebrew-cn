class Libsail < Formula
  desc "Missing small and fast image decoding library for humans (not for machines)"
  homepage "https://sail.software"
  url "https://ghfast.top/https://github.com/HappySeaFox/sail/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "586df996e499b8978b9217f0079a3b90abeea3bd6f59e27f4bf5f83c7acec804"
  license "MIT"

  bottle do
    sha256 arm64_golden_gate: "ac94e35789a296f17bc23560e0d1a96a23bbfe0902624aacd66418513cd8f025"
    sha256 arm64_tahoe:       "a5c17f58c48d26277888eedc1352333854237079c1642e4e2be0824b81c2bae9"
    sha256 arm64_sequoia:     "c20b32d02b99e81353b0b23a1935ae80113a46e8a479e9946e1da51709a12acd"
    sha256 arm64_linux:       "bc3531212fec47c5ec2c10ebe7e78de3ad8f54edbd9d2f9895302ba061b885e3"
    sha256 x86_64_linux:      "8e29929c22d66d47d6b96069ed224ce46053e835988bbfbfb9201cfd7b996ead"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "ffmpeg" # for `libavutil`
  depends_on "giflib"
  depends_on "imath"
  depends_on "jpeg-turbo"
  depends_on "jpeg-xl"
  depends_on "libavif"
  depends_on "libheif"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "openexr"
  depends_on "openjpeg"
  depends_on "resvg"
  depends_on "webp"

  on_macos do
    depends_on "brotli"
    depends_on "highway"
    depends_on "little-cms2"
    depends_on "xz"
  end

  deny_network_access!

  def install
    args = %W[
      -DCMAKE_INSTALL_RPATH=#{rpath};#{rpath(source: lib/"sail/codecs")}
      -DSAIL_BUILD_EXAMPLES=OFF
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # To prevent conflicts with 'sail' formula
    mv "#{bin}/sail", "#{bin}/sail-imaging"
  end

  test do
    system bin/"sail-imaging", "decode", test_fixtures("test.png")

    (testpath/"test.c").write <<~C
      #include <sail/sail.h>

      int main(int argc, char **argv)
      {
          struct sail_image *image;
          SAIL_TRY_OR_EXECUTE(sail_load_from_file(argv[1], &image),
                                /* on error */ return 1);
          sail_destroy_image(image);

          return 0;
      }
    C

    system ENV.cc, "test.c", "-o", "test", "-I#{include}/sail", "-L#{lib}", "-lsail", "-lsail-common"
    system "./test", test_fixtures("test.jpg")
  end
end