class Grokj2k < Formula
  desc "JPEG 2000 Library"
  homepage "https:github.comGrokImageCompressiongrok"
  # pull from git tag to get submodules
  url "https:github.comGrokImageCompressiongrok.git",
      tag:      "v13.0.2",
      revision: "3b7365060a9f03ece1e751485c4719b824c3990f"
  license "AGPL-3.0-or-later"
  head "https:github.comGrokImageCompressiongrok.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "7d98d439c8e8934860451a44dd70b8be13fdc2476baf761623a511503cfca7c2"
    sha256 cellar: :any,                 arm64_sonoma:  "40674037784abe4e7c1303e2a6e145987b94d947d584b49e515d5560feb7dc77"
    sha256 cellar: :any,                 arm64_ventura: "4aad900ead14c54f28e4821e67a5a10a19e3fddcb918bca51797c0f55af60327"
    sha256 cellar: :any,                 sonoma:        "e0a4c61b0a16ff6643e95a2b9792b9dce7f32846c6d982c980df9273499d68d0"
    sha256 cellar: :any,                 ventura:       "8f83006b9afb880466a8bd0027ef6b0efcc0b248803b1e2c9633e00e8919d877"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "de23e73b5d41a860ccca182be18ae5c6cd022a63d9e8b19b0ba801b45f53a270"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "pkgconf" => :build
  depends_on "exiftool"
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "little-cms2"
  depends_on macos: :catalina

  uses_from_macos "perl"
  uses_from_macos "zlib"

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1200
    depends_on "xz"
    depends_on "zstd"
  end

  fails_with :clang do
    build 1200
    cause "Requires C++20"
  end

  # https:github.comGrokImageCompressiongrokblobmasterINSTALL.md#compilers
  fails_with :gcc do
    version "9"
    cause "GNU compiler version must be at least 10.0"
  end

  def install
    ENV.llvm_clang if OS.mac? && (DevelopmentTools.clang_build_version <= 1200)

    # Fix: ExifTool Perl module not found
    ENV.prepend_path "PERL5LIB", Formula["exiftool"].opt_libexec"lib"

    # Ensure we use Homebrew libraries
    %w[liblcms2 libpng libtiff libz].each { |l| rm_r(buildpath"thirdparty"l) }

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
      args << "-DPERL_INCLUDE_PATH=#{MacOS.sdk_path_if_needed}#{perl_archlib}CORE"
    else
      # Fix linkage error due to RPATH missing directory with libperl.so
      ENV.append "LDFLAGS", "-Wl,-rpath,#{perl_archlib}CORE"
    end

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    include.install_symlink "grok-#{version.major_minor}" => "grok"

    bin.env_script_all_files libexec, PERL5LIB: ENV["PERL5LIB"]
  end

  test do
    resource "homebrew-test_image" do
      url "https:github.comGrokImageCompressiongrok-test-dataraw43ce4cbinputnonregressionbasn6a08.tif"
      sha256 "d0b9715d79b10b088333350855f9721e3557b38465b1354b0fa67f230f5679f3"
    end

    (testpath"test.c").write <<~C
      #include <grokgrok.h>

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
    system ".test"

    # Test Exif metadata retrieval
    testpath.install resource("homebrew-test_image")
    system bin"grk_compress", "--in-file", "basn6a08.tif",
                               "--out-file", "test.jp2", "--out-fmt", "jp2",
                               "--transfer-exif-tags"
    output = shell_output("#{Formula["exiftool"].bin}exiftool test.jp2")

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