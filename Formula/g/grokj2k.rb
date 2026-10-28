class Grokj2k < Formula
  desc "JPEG 2000 Library"
  homepage "https://github.com/GrokImageCompression/grok"
  url "https://ghfast.top/https://github.com/GrokImageCompression/grok/releases/download/v20.4.20/source-full.tar.gz"
  sha256 "2e2053a8c31654eae6938cd517471d308d5ce59905afbc0fde35e72c3d50629b"
  license "AGPL-3.0-or-later"
  head "https://github.com/GrokImageCompression/grok.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "c87fc3e9c2b7a99782cc0355b5d5e1cb775fe45495a401a286a2e330b395c789"
    sha256 cellar: :any, arm64_tahoe:       "d24dfa9092ab6d96716b1d6a229bc4220848347a086827bd25c811e0470b2a1f"
    sha256 cellar: :any, arm64_sequoia:     "8e5da9501bb109a15fba973a43162e2cfa9347f457816ede27ae11ef9d24f5cb"
    sha256 cellar: :any, arm64_linux:       "2dbbc3a2dd988c793d2c151c198088b207c63ae9fd60acb1391ff1520d0523e8"
    sha256 cellar: :any, x86_64_linux:      "3c6be641e9d1a9a6ad6ad64fe05afce03c379763ed850cf271c37235292dc735"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "exiftool" => :test
  depends_on "fmt"
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "little-cms2"

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version < 1700
    depends_on "xz"
    depends_on "zstd"
  end

  on_linux do
    depends_on "zlib-ng-compat"
  end

  fails_with :clang do
    build 1699
    cause "Requires C++20"
  end

  # https://github.com/GrokImageCompression/grok/blob/master/INSTALL.md#compilers
  fails_with :gcc do
    version "9"
    cause "GNU compiler version must be at least 10.0"
  end

  resource "homebrew-test_image", :test do
    url "https://github.com/GrokImageCompression/grok-test-data/raw/43ce4cb/input/nonregression/basn6a08.tif"
    sha256 "d0b9715d79b10b088333350855f9721e3557b38465b1354b0fa67f230f5679f3"
  end

  allow_network_access! :test

  def install
    # Ensure we use Homebrew libraries
    %w[liblcms2 libpng libtiff libz].each { |l| rm_r(buildpath/"thirdparty"/l) }

    args = %w[
      -DGRK_BUILD_CORE_EXAMPLES=OFF
      -DGRK_BUILD_DOC=OFF
      -DGRK_BUILD_JPEG=OFF
      -DGRK_BUILD_LCMS2=OFF
      -DGRK_BUILD_LIBPNG=OFF
      -DGRK_BUILD_LIBTIFF=OFF
      -DSPDLOG_FMT_EXTERNAL=ON
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    include.install_symlink "grok-#{version.major_minor}" => "grok"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <grok/grok.h>

      int main () {
        grk_image_comp cmptparm;
        const GRK_COLOR_SPACE color_space = GRK_CLRSPC_GRAY;

        grk_image *image;
        image = grk_image_new(1, &cmptparm, color_space, true);

        grk_object_unref(&image->obj);
        return 0;
      }
    C
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lgrokj2k", "-o", "test"
    system "./test"

    # Test metadata preservation
    testpath.install resource("homebrew-test_image")
    system bin/"grk_compress", "--in-file", "basn6a08.tif",
                               "--out-file", "test.jp2", "--out-fmt", "jp2"
    output = shell_output("#{formula_opt_bin("exiftool")}/exiftool test.jp2")

    expected_fields = [
      "Capture X Resolution            : 2835",
      "Capture Y Resolution            : 2835",
      "Capture X Resolution Unit       : m",
      "Capture Y Resolution Unit       : m",
    ]

    expected_fields.each do |field|
      assert_match field, output
    end
  end
end