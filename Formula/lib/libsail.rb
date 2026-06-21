class Libsail < Formula
  desc "Missing small and fast image decoding library for humans (not for machines)"
  homepage "https://sail.software"
  url "https://ghfast.top/https://github.com/HappySeaFox/sail/archive/refs/tags/v1.0.1.tar.gz"
  sha256 "0f4957dd302165b3cfa23be7401b634d4ac87539552cdaf32f8c206febf9860a"
  license "MIT"

  bottle do
    sha256 arm64_tahoe:   "0c6e2d5815cca5fae947843f201e51d25103118ca8b589f94f598fefaaba6556"
    sha256 arm64_sequoia: "6c27e3146ccc99e9198fea0afd2d64b1cfcf72761b7b1f854a49911d1ae0ce70"
    sha256 arm64_sonoma:  "83c77a33be7a6170366de89846920df7d3fbae6edb8a2eb60e1a959c13271e73"
    sha256 sonoma:        "e4c7442d9caaca2a330f684d172aa77300e4f645a47ef64075caf7c5e6ec4a5a"
    sha256 arm64_linux:   "59e7b2331219890eff05e102fffd7a34e9b6e35de08629c35a0520493863ed84"
    sha256 x86_64_linux:  "bbcaafde52e6b8b68b4893b3f99a6af1986eb04954dba811e5697e7f40046039"
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