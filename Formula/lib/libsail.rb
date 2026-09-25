class Libsail < Formula
  desc "Missing small and fast image decoding library for humans (not for machines)"
  homepage "https://sail.software"
  url "https://ghfast.top/https://github.com/HappySeaFox/sail/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "fe2673d76e8088084447f388b94b4639f060afec4fab4e080e493049fbb24bf2"
  license "MIT"
  revision 1

  bottle do
    sha256 arm64_golden_gate: "e09a763116e7c282df8374e004538111d29a96edbcb5c0b88e7b7ed52387c4f6"
    sha256 arm64_tahoe:       "80a9bd81cdf68b81cc545711c31cabe522b23ca105f1b144e0d51888e793db84"
    sha256 arm64_sequoia:     "b705ff94784f2cd13f575bf96aadd088d4525da5aa17ce45b3f3d5a939927511"
    sha256 arm64_linux:       "0c5cfedc418a52ba343522dc98d9d690254e74b0ee41b780b34e12166bd3d0b9"
    sha256 x86_64_linux:      "5afdb283b316ad83adec1799dcc464fd2a1b52aaa7994bbad891110014838798"
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

    flags = shell_output("#{formula_opt_bin("pkgconf")}/pkgconf --cflags --libs sail").strip.split

    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test", test_fixtures("test.jpg")
  end
end