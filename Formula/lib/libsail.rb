class Libsail < Formula
  desc "Missing small and fast image decoding library for humans (not for machines)"
  homepage "https:github.comHappySeaFoxsail"
  url "https:github.comHappySeaFoxsailarchiverefstagsv0.9.5.tar.gz"
  sha256 "28c601c0399be1940710afc150b5836f8b3f5f6a35b98d7ac1467e62bc568e20"
  license "MIT"
  revision 1

  bottle do
    sha256 arm64_sequoia: "9d63be7127fd7b253c2a2cb62ee3170fa44d14f5aa42ac30d490e6925110f2bc"
    sha256 arm64_sonoma:  "2b5e1cf61ac93541c9cc88dc541fcc5efc2bdf845ee2dcd11b6dcf9b9fe075e4"
    sha256 arm64_ventura: "336e94e6f697c0f57cf748b258e0031be67f45d0d3b5b43e996c968928046639"
    sha256 sonoma:        "348914ec9947ac27567a5279a417854081cde40abadb36c8b63f6d488dc690a3"
    sha256 ventura:       "f9bfc91f552a24e6aa4f3f8bcb0115b57c7070a6fd829c6ebeacfa26980b891a"
    sha256 x86_64_linux:  "b3c59cbf10e596d7c118ed25bac52298105e2d5f6e280e6867bf72b123442de2"
  end

  depends_on "cmake"      => :build
  depends_on "pkg-config" => [:build, :test]
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
    mv "#{bin}sail", "#{bin}sail-imaging"
  end

  test do
    system bin"sail-imaging", "decode", test_fixtures("test.png")

    (testpath"test.c").write <<~EOS
      #include <sailsail.h>

      int main(int argc, char **argv)
      {
          struct sail_image *image;
          SAIL_TRY_OR_EXECUTE(sail_load_from_file(argv[1], &image),
                                * on error * return 1);
          sail_destroy_image(image);

          return 0;
      }
    EOS

    cflags = shell_output("#{Formula["pkg-config"].opt_bin}pkg-config --cflags sail").strip.split
    libs   = shell_output("#{Formula["pkg-config"].opt_bin}pkg-config --libs sail").strip.split

    system ENV.cc, *cflags, "test.c", "-o", "test", *libs
    system ".test", test_fixtures("test.jpg")
  end
end