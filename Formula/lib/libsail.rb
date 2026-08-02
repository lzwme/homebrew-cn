class Libsail < Formula
  desc "Missing small and fast image decoding library for humans (not for machines)"
  homepage "https://sail.software"
  url "https://ghfast.top/https://github.com/HappySeaFox/sail/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "fceb5691680ef19cdf46c21e01f34fec1ff68dcc8c7061b32d66c574746a0b7c"
  license "MIT"

  bottle do
    sha256 arm64_tahoe:   "d5bcb4d000c095cd52377da59927e0d3ce5aa815c07dbd9b9c075e399867a154"
    sha256 arm64_sequoia: "8bd3c0311a6a2d9403d4ca375cfd9db9f00d00b36b1c2c83176074622580c841"
    sha256 arm64_sonoma:  "e09ee1172a2bcc1da1e34d700a4e45d94689807254c08ff071353d349c649d27"
    sha256 sonoma:        "9db463f3d8383d917ce1f2d60d8ec19e9b7749f5cb2456d591614be50bd67ea7"
    sha256 arm64_linux:   "ef4bde6bef99c24354055aaeab12f580e4de40b34eab658a6b8740f3af9e8344"
    sha256 x86_64_linux:  "e296857b5fb4cfde0781de9b60e61bdc180818186cd47c46acf29596d0de47f3"
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

    flags = shell_output("#{formula_opt_bin("pkgconf")}/pkgconf --cflags --libs sail").strip.split

    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test", test_fixtures("test.jpg")
  end
end