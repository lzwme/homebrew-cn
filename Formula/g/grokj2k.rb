class Grokj2k < Formula
  desc "JPEG 2000 Library"
  homepage "https://github.com/GrokImageCompression/grok"
  # pull from git tag to get submodules
  url "https://github.com/GrokImageCompression/grok.git",
      tag:      "v20.0.0",
      revision: "5770f12eac84820debe2afa65638dc9d587a4f9e"
  license "AGPL-3.0-or-later"
  head "https://github.com/GrokImageCompression/grok.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "5e3f2f0a6f64ab8409195d20817bcca36440c9fd5f1736b3f4ebc5607f428325"
    sha256 cellar: :any,                 arm64_sequoia: "3ca104603fc218db1f5c8c7dd2921a65de97432b6cdc946f1a502a7e322a1440"
    sha256 cellar: :any,                 arm64_sonoma:  "0ececc2a91cb03cfd8ca9c72c1bf7c6757cdfe80cc7cc919df6da9b99743a114"
    sha256 cellar: :any,                 sonoma:        "e21bb0dfd2cbe9a56fc92f40dbf44398474eb4c18fd6ec21b728bf614598530e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5b9caf1a7568dd9833350fa9f8c3994146b89db252d51ff7f0dcb969258a42da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "801e37ee5f357e217db83144cfed3e51fb6dca2c8f0d408cf71a849b52be589f"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "pkgconf" => :build
  depends_on "exiftool"
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "little-cms2"

  uses_from_macos "perl"
  uses_from_macos "zlib"

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version < 1700
    depends_on "xz"
    depends_on "zstd"
  end

  fails_with :clang do
    build 1200
    cause "Requires C++20"
  end

  # https://github.com/GrokImageCompression/grok/blob/master/INSTALL.md#compilers
  fails_with :gcc do
    version "9"
    cause "GNU compiler version must be at least 10.0"
  end

  def install
    ENV.llvm_clang if OS.mac? && (DevelopmentTools.clang_build_version < 1700)

    # Fix: ExifTool Perl module not found
    ENV.prepend_path "PERL5LIB", Formula["exiftool"].opt_libexec/"lib/perl5"

    # Ensure we use Homebrew libraries
    %w[liblcms2 libpng libtiff libz].each { |l| rm_r(buildpath/"thirdparty"/l) }

    perl = DevelopmentTools.locate("perl")
    perl_archlib = Utils.safe_popen_read(perl.to_s, "-MConfig", "-e", "print $Config{archlib}")
    args = %W[
      -DGRK_BUILD_DOC=ON
      -DGRK_BUILD_JPEG=OFF
      -DGRK_BUILD_LCMS2=OFF
      -DGRK_BUILD_LIBPNG=OFF
      -DGRK_BUILD_LIBTIFF=OFF
      -DPERL_EXECUTABLE=#{perl}
    ]

    if OS.mac?
      # Workaround Perl 5.18 issues with C++11: pad.h:323:17: error: invalid suffix on literal
      ENV.append "CXXFLAGS", "-Wno-reserved-user-defined-literal" if MacOS.version <= :catalina
      # Help CMake find Perl libraries, which are needed to enable ExifTool feature.
      # Without this, CMake outputs: Could NOT find PerlLibs (missing: PERL_INCLUDE_PATH)
      args << "-DPERL_INCLUDE_PATH=#{MacOS.sdk_path_if_needed}/#{perl_archlib}/CORE"
    else
      # Fix linkage error due to RPATH missing directory with libperl.so
      ENV.append "LDFLAGS", "-Wl,-rpath,#{perl_archlib}/CORE"
    end

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    include.install_symlink "grok-#{version.major_minor}" => "grok"

    bin.env_script_all_files libexec, PERL5LIB: ENV["PERL5LIB"]
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

    # Test Exif metadata retrieval
    testpath.install resource("homebrew-test_image")
    system bin/"grk_compress", "--in-file", "basn6a08.tif",
                               "--out-file", "test.jp2", "--out-fmt", "jp2",
                               "--transfer-exif-tags"
    output = shell_output("#{Formula["exiftool"].bin}/exiftool test.jp2")

    expected_fields = [
      "Exif Byte Order                 : Big-endian (Motorola, MM)",
      "Orientation                     : Horizontal (normal)",
      "X Resolution                    : 72",
      "Y Resolution                    : 72",
      "Resolution Unit                 : inches",
      "Y Cb Cr Positioning             : Centered",
    ]

    expected_fields.each do |field|
      assert_match field, output
    end
  end
end