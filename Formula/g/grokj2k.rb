class Grokj2k < Formula
  desc "JPEG 2000 Library"
  homepage "https:github.comGrokImageCompressiongrok"
  url "https:github.comGrokImageCompressiongrokarchiverefstagsv11.0.1.tar.gz"
  sha256 "8e8bd9f25a26f64464b7783dee3f1670d775c47c9fb40a4c0c25bb592eddc19a"
  license "AGPL-3.0-or-later"
  head "https:github.comGrokImageCompressiongrok.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "940ec8dd75045079d25a2467099a3a13131c64131c682b854c50877df138ea2a"
    sha256 cellar: :any,                 arm64_ventura:  "10b1d9a848d5104e4bdab2215d704db602fefa18b1691e5f3fad80dfd14d7606"
    sha256 cellar: :any,                 arm64_monterey: "57e8c62117fea52f12413ccc205f13e241e6b50e508abb2f646c6e91e794bcc0"
    sha256 cellar: :any,                 sonoma:         "c6bd01f085d7f4542816704c6fe6be4536333e7868805d8e21b1a66be1b2fb98"
    sha256 cellar: :any,                 ventura:        "f58cc48905acd70da8a814858c95e5234e01c11f2c337567cd662ef19beb93b6"
    sha256 cellar: :any,                 monterey:       "8b7b4bcf32e223e99b7629af82989512fe9df5f54bab5b711ce57ba12db5633b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b6540196f41b4e65792b699124c24ea9b48b311c63029348e278c7c11974a2dc"
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