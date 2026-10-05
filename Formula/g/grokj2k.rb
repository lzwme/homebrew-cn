class Grokj2k < Formula
  desc "JPEG 2000 Library"
  homepage "https://github.com/GrokImageCompression/grok"
  url "https://ghfast.top/https://github.com/GrokImageCompression/grok/releases/download/v20.4.15/source-full.tar.gz"
  sha256 "b1887a7c5db553c39d89fdcae031820dad8873cac4dec75c509e57317f92ab3f"
  license "AGPL-3.0-or-later"
  head "https://github.com/GrokImageCompression/grok.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "9f974f3887d117511955cef9a529395b5778bb161b1c5b5b1afb7f8154d821a4"
    sha256 cellar: :any, arm64_tahoe:       "8bb0be515890b254fb2eabf45e1b8a7ef4905af92cfa77544c9c4307ad5d4696"
    sha256 cellar: :any, arm64_sequoia:     "7209d91292ee6bcf77521599ad2eee9ca766fc7896e43fc2a9d88a0910902c42"
    sha256 cellar: :any, arm64_linux:       "8deff3e9812980820ce6f0353bb8907530fdc0074a7e0d889a7c4c20a2db7f66"
    sha256 cellar: :any, x86_64_linux:      "647f604d06e1ed2e15e92915929841ce6564604847e640a546bbe0e95a4a8e19"
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
    resource "homebrew-test_image" do
      url "https://github.com/GrokImageCompression/grok-test-data/raw/43ce4cb/input/nonregression/basn6a08.tif"
      sha256 "d0b9715d79b10b088333350855f9721e3557b38465b1354b0fa67f230f5679f3"
    end

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