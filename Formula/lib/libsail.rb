class Libsail < Formula
  desc "Missing small and fast image decoding library for humans (not for machines)"
  homepage "https:github.comHappySeaFoxsail"
  url "https:github.comHappySeaFoxsailarchiverefstagsv0.9.0.tar.gz"
  sha256 "892738e0f56fed8c6387e1045bba2bfbf1b095024a495845d4879edb310cd1a7"
  license "MIT"

  bottle do
    sha256 arm64_sonoma:   "65920d269a4808976c62a633c44842392a14782f40f7c8d2ae13cf3690aca4d6"
    sha256 arm64_ventura:  "72e3d594e8f0969372ea6185a49e067cd3d7413d7e57f8c56bf1ee56111f93df"
    sha256 arm64_monterey: "2460273c0459e5c506ae0fe2549b3773e524cda54e52ea0dda76c69726b9b329"
    sha256 sonoma:         "61db1c9ae86851397c187f5eff9c2220c70202c82d1192b7a969b8fb2c2fdd9a"
    sha256 ventura:        "07b58b25676f108676432feb75dfb10b8d1be3a518452058dab8f3bbf630ec43"
    sha256 monterey:       "f4431c1af8d6e5cd39340766bf48f94558bc65b8c2fb9a8fd1af9e62af261b24"
    sha256 x86_64_linux:   "5078ea7828d61766f094b081970e4127c9fed853f13bfed8b34895921977da36"
  end

  depends_on "cmake"      => :build
  depends_on "pkg-config" => [:build, :test]

  depends_on "giflib"
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
    system "#{bin}sail-imaging", "decode", test_fixtures("test.png")

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