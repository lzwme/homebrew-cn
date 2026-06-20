class Libsail < Formula
  desc "Missing small and fast image decoding library for humans (not for machines)"
  homepage "https://sail.software"
  url "https://ghfast.top/https://github.com/HappySeaFox/sail/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "b6f77d6d451b72202c8e11bd5057b697a21f7b6c4ef713f19a96de5a16c08916"
  license "MIT"

  bottle do
    sha256 arm64_tahoe:   "ae14f0829509fe776aa18a3798dcccf534fc6c4899c4566d22916295957a505a"
    sha256 arm64_sequoia: "6ac971d38f6126f01d0e474878079b6ce4855a7bd8e763f2db11f7e90edd5a62"
    sha256 arm64_sonoma:  "42e64caded31c4b11d3c345c84e81be0e96976220c8affeab14af9f409b2a1f7"
    sha256 sonoma:        "92271e1e53859d9f21451f5d02f8fab25ff057b5f21a5beead6087e619e11fda"
    sha256 arm64_linux:   "2c8c29756800e5477ee9bec70bd10114355196092f443774d85fb4813aad1c9a"
    sha256 x86_64_linux:  "b578cbe8533beaf35ef965f08e894b17ed5710b7de5c7c04c94af98ff7800adc"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => [:build, :test]
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
  end

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

    flags = shell_output("#{Formula["pkgconf"].opt_bin}/pkgconf --cflags --libs sail").strip.split

    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test", test_fixtures("test.jpg")
  end
end