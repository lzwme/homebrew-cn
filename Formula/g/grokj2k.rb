class Grokj2k < Formula
  desc "JPEG 2000 Library"
  homepage "https:github.comGrokImageCompressiongrok"
  # pull from git tag to get submodules
  url "https:github.comGrokImageCompressiongrok.git",
      tag:      "v13.0.1",
      revision: "4b1049297bfb93a0f2afbe598f4dab92545ee1ad"
  license "AGPL-3.0-or-later"
  revision 1
  head "https:github.comGrokImageCompressiongrok.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "58dfe423810794c2595923d5d9e7abb452dcad85b40b9f4c98749f136a5a771d"
    sha256 cellar: :any,                 arm64_sonoma:  "f21704c74f8dc06776204ad4c0a58542e98f1547b8d516ba20828d2ac3c57410"
    sha256 cellar: :any,                 arm64_ventura: "de74ecf571e653a544424ea6d448e84e3ecd461100824e3d33d382dba4fafa8e"
    sha256 cellar: :any,                 sonoma:        "975512767859e6ea6b65ee19596cd09375d10ec224dc0f3d7daebde8ab03d243"
    sha256 cellar: :any,                 ventura:       "543cf0939cfe32eb7f35e5c5c26ba0bf85646c261580bba9fb9ce9a6b75ed172"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8c1c38b58a780f45247ca444fc92540cd0d3a66d95b3af14a789e23d8151f48a"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "pkg-config" => :build
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

    # Ensure we use Homebrew little-cms2
    %w[liblcms2 libpng libtiff libz].each { |l| rm_r(buildpath"thirdparty"l) }
    inreplace "thirdpartyCMakeLists.txt" do |s|
      s.gsub! "add_subdirectory(liblcms2)", ""
      s.gsub! %r{(set\(LCMS_INCLUDE_DIRNAME) \$\{GROK_SOURCE_DIR\}thirdpartyliblcms2include},
              "\\1 #{Formula["little-cms2"].opt_include}"
    end

    perl = DevelopmentTools.locate("perl")
    perl_archlib = Utils.safe_popen_read(perl.to_s, "-MConfig", "-e", "print $Config{archlib}")
    args = %W[
      -DGRK_BUILD_DOC=ON
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

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    include.install_symlink "grok-#{version.major_minor}" => "grok"

    bin.env_script_all_files libexec, PERL5LIB: ENV["PERL5LIB"]
  end

  test do
    resource "homebrew-test_image" do
      url "https:github.comGrokImageCompressiongrok-test-dataraw43ce4cbinputnonregressionpngsuitebasn0g01.png"
      sha256 "c23c1848002082e128f533dc3c24a49fc57329293cc1468cc9dc36339b1abcac"
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
    system bin"grk_compress", "--in-file", "basn0g01.png",
                                "--out-file", "test.jp2", "--out-fmt", "jp2",
                                "--transfer-exif-tags"
    output = shell_output("#{Formula["exiftool"].bin}exiftool test.jp2")

    expected_fields = [
      "File Type                       : JP2",
      "MIME Type                       : imagejp2",
      "Major Brand                     : JPEG 2000 Image (.JP2)",
      "Compatible Brands               : jp2",
      "Image Height                    : 32",
      "Image Width                     : 32",
      "Bits Per Component              : 1 Bits, Unsigned",
      "Compression                     : JPEG 2000",
    ]

    expected_fields.each do |field|
      assert_match field, output
    end
  end
end