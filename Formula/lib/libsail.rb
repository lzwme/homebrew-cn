class Libsail < Formula
  desc "Missing small and fast image decoding library for humans (not for machines)"
  homepage "https://github.com/HappySeaFox/sail"
  url "https://ghfast.top/https://github.com/HappySeaFox/sail/archive/refs/tags/v0.9.10.tar.gz"
  sha256 "dc0d6fa87cb4fa8b514f450a3fb13cee6e3e60f03250f683564fabbec0f722e3"
  license "MIT"

  bottle do
    sha256 arm64_tahoe:   "5f8c26637695566448fa06d5d0a50084a7b96faf043eacc0515e4d0615e8fa46"
    sha256 arm64_sequoia: "c2242a57c2f70c09b7a3e5a09480918918b126ad846872fb16301c83a65b4c1a"
    sha256 arm64_sonoma:  "9e295402ffb36ae6796aeaccc7961b9041b06db326cde6a5792bd711eb8554b0"
    sha256 sonoma:        "9ec2e97cf986e38e03f87556bb5a2f3c387255e345055393d967fb1c39fba651"
    sha256 arm64_linux:   "0545edbea8c330c3c0fbee704dfafd6087273605390c7f73980d1ee3c9cf3359"
    sha256 x86_64_linux:  "a49701c77fa8b909f562cd097424bb2e608d7ddb629737a50ca64adf547b7349"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "brotli"
  depends_on "giflib"
  depends_on "highway"
  depends_on "jasper"
  depends_on "jpeg-turbo"
  depends_on "jpeg-xl"
  depends_on "libavif"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "resvg"
  depends_on "webp"

  def install
    args = %W[
      -DCMAKE_INSTALL_RPATH=#{rpath}
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