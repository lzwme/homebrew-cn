class Libsail < Formula
  desc "Missing small and fast image decoding library for humans (not for machines)"
  homepage "https://sail.software"
  url "https://ghfast.top/https://github.com/HappySeaFox/sail/archive/refs/tags/v1.0.2.tar.gz"
  sha256 "9534b24c491f4574b32560ff4e13ac5e1396050370a201a8a403e4a593d60dc0"
  license "MIT"

  bottle do
    sha256 arm64_tahoe:   "0bc2f8ff3e30fe47461d3927acf30e03fa1f67dc5160ce4a246fe342da15364c"
    sha256 arm64_sequoia: "f52bab9d9285e8a982434a5d1afa38190270fb271cf4ba2e759fb1caab8290b8"
    sha256 arm64_sonoma:  "9a297e697d9c32906f3a05c4c45e69fb86f4238415d2d60db8647b28585e9c47"
    sha256 sonoma:        "83840a2d0cdbaea5fdb406a734710e8bc7f2c38cd26b15bb7a5cdc3f7b868c7b"
    sha256 arm64_linux:   "2c3b9c55635d96ccaf5ae66dd51af14cd4b20818ed579549f1f47723139b91a1"
    sha256 x86_64_linux:  "7ecdda2cad47ca7ea14a57a4dcdad4488b68c949fd0a38a9fe79bc160149235c"
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