class Grokj2k < Formula
  desc "JPEG 2000 Library"
  homepage "https:github.comGrokImageCompressiongrok"
  url "https:github.comGrokImageCompressiongrokarchiverefstagsv12.0.3.tar.gz"
  sha256 "8f35ea6559c7ce6f17268b16a6642fa704a64a81a7c35daa045466b11ad4a274"
  license "AGPL-3.0-or-later"
  head "https:github.comGrokImageCompressiongrok.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "2895a3f184fff6ed582fe8deaf8263269d8fd8d96b32eb6daa26bd65de1193b5"
    sha256 cellar: :any,                 arm64_ventura:  "5a1641b959e88ba1833188551443f562cf6627b5fe6fadf2b213f32d80b7972a"
    sha256 cellar: :any,                 arm64_monterey: "efae536e36b219da4b8bb9a8ed6bd0cd443ebe8b342c8a333d4f65bb1a3fde4d"
    sha256 cellar: :any,                 sonoma:         "097f484b713a0663c571eaab77ca75f01ebe3a146195eb9f4acee8eb04736865"
    sha256 cellar: :any,                 ventura:        "3fcb01eff880bb5b7d9438d2fcb2816a2dade94a8fd5db117cb15844a3c454fb"
    sha256 cellar: :any,                 monterey:       "6802006a793137e7572f8fa259f76accdc6f2699b3d1e951a7ec2c92d9abe35e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "04bcaeee0c78b07d889c39518b9a740d9097987f843ee6b507e44d43d03226b2"
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
    %w[liblcms2 libpng libtiff libz].each { |l| (buildpath"thirdparty"l).rmtree }
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
      url "https:github.comGrokImageCompressiongrok-test-dataraw43ce4cbinputnonregressionbasn6a08.tif"
      sha256 "d0b9715d79b10b088333350855f9721e3557b38465b1354b0fa67f230f5679f3"
    end

    (testpath"test.c").write <<~EOS
      #include <grokgrok.h>

      int main () {
        grk_image_comp cmptparm;
        const GRK_COLOR_SPACE color_space = GRK_CLRSPC_GRAY;

        grk_image *image;
        image = grk_image_new(1, &cmptparm, color_space, true);

        grk_object_unref(&image->obj);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lgrokj2k", "-o", "test"
    system ".test"

    # Test Exif metadata retrieval
    resource("homebrew-test_image").stage do
      system bin"grk_compress", "-in_file", "basn6a08.tif",
                                 "-out_file", "test.jp2", "-out_fmt", "jp2",
                                 "-transfer_exif_tags"
      output = shell_output("#{Formula["exiftool"].bin}exiftool test.jp2")

      [
        "Exif Byte Order                 : Big-endian (Motorola, MM)",
        "Orientation                     : Horizontal (normal)",
        "X Resolution                    : 72",
        "Y Resolution                    : 72",
        "Resolution Unit                 : inches",
        "Y Cb Cr Positioning             : Centered",
      ].each do |data|
        assert_match data, output
      end
    end
  end
end