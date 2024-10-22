class JpegXl < Formula
  desc "New file format for still image compression"
  homepage "https:jpeg.orgjpegxlindex.html"
  url "https:github.comlibjxllibjxlarchiverefstagsv0.11.0.tar.gz"
  sha256 "7ce4ec8bb37a435a73ac18c4c9ff56c2dc6c98892bf3f53a328e3eca42efb9cf"
  license "BSD-3-Clause"
  revision 1

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "a872b8c7a7f18381dc62c164f6e38de1750de1909de14ae2f5cbca72c0da93d6"
    sha256 cellar: :any,                 arm64_sonoma:  "a5ccfecd1eb7d5997c1aec2e904846031a4c990f175aed3ab4a5a1bdc783a500"
    sha256 cellar: :any,                 arm64_ventura: "7f176bd80a18add2adb418755b29f1c6165f6e3e2a016c9ab029ccaa67ba959b"
    sha256 cellar: :any,                 sonoma:        "5d8a0e9b7344952bc35481d52e0cc045f106775fdd0e47c7fcb1bf563b1e398b"
    sha256 cellar: :any,                 ventura:       "64deb00f3a86e43b905ccf527af915f4d6f0a6d16e39b99c89df45aa698605ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "11a5997b6ed08cba8626d3b9df0a03db954c96eb200866b7799d0a2eb269e572"
  end

  depends_on "asciidoc" => :build
  depends_on "cmake" => :build
  depends_on "docbook-xsl" => :build
  depends_on "doxygen" => :build
  depends_on "pkg-config" => :build
  depends_on "sphinx-doc" => :build
  depends_on "pkg-config" => :test
  depends_on "brotli"
  depends_on "giflib"
  depends_on "highway"
  depends_on "imath"
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "little-cms2"
  depends_on "openexr"
  depends_on "webp"

  uses_from_macos "libxml2" => :build
  uses_from_macos "libxslt" => :build # for xsltproc
  uses_from_macos "python"

  fails_with gcc: "5"
  fails_with gcc: "6"

  # These resources are versioned according to the script supplied with jpeg-xl to download the dependencies:
  # https:github.comlibjxllibjxltreev#{version}third_party
  resource "sjpeg" do
    url "https:github.comwebmprojectsjpeg.git",
        revision: "e5ab13008bb214deb66d5f3e17ca2f8dbff150bf"
  end

  def install
    ENV.append_path "XML_CATALOG_FILES", HOMEBREW_PREFIX"etcxmlcatalog"
    resources.each { |r| r.stage buildpath"third_party"r.name }
    system "cmake", "-S", ".", "-B", "build",
                    "-DJPEGXL_FORCE_SYSTEM_BROTLI=ON",
                    "-DJPEGXL_FORCE_SYSTEM_LCMS2=ON",
                    "-DJPEGXL_FORCE_SYSTEM_HWY=ON",
                    "-DJPEGXL_ENABLE_DEVTOOLS=ON",
                    "-DJPEGXL_ENABLE_JNI=OFF",
                    "-DJPEGXL_ENABLE_JPEGLI=OFF",
                    "-DJPEGXL_ENABLE_SKCMS=OFF",
                    "-DJPEGXL_VERSION=#{version}",
                    "-DJPEGXL_ENABLE_MANPAGES=ON",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    "-DPython_EXECUTABLE=#{Formula["asciidoc"].libexec"binpython"}",
                    "-DPython3_EXECUTABLE=#{Formula["asciidoc"].libexec"binpython3"}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--build", "build", "--target", "install"
  end

  test do
    system bin"cjxl", test_fixtures("test.jpg"), "test.jxl"
    assert_predicate testpath"test.jxl", :exist?

    (testpath"jxl_test.c").write <<~C
      #include <jxlencode.h>
      #include <stdlib.h>

      int main()
      {
          JxlEncoder* enc = JxlEncoderCreate(NULL);
          if (enc == NULL) {
            return EXIT_FAILURE;
          }
          JxlEncoderDestroy(enc);
          return EXIT_SUCCESS;
      }
    C
    jxl_flags = shell_output("pkg-config --cflags --libs libjxl").chomp.split
    system ENV.cc, "jxl_test.c", *jxl_flags, "-o", "jxl_test"
    system ".jxl_test"

    (testpath"jxl_threads_test.c").write <<~C
      #include <jxlthread_parallel_runner.h>
      #include <stdlib.h>

      int main()
      {
          void* runner = JxlThreadParallelRunnerCreate(NULL, 1);
          if (runner == NULL) {
            return EXIT_FAILURE;
          }
          JxlThreadParallelRunnerDestroy(runner);
          return EXIT_SUCCESS;
      }
    C
    jxl_threads_flags = shell_output("pkg-config --cflags --libs libjxl_threads").chomp.split
    system ENV.cc, "jxl_threads_test.c", *jxl_threads_flags, "-o", "jxl_threads_test"
    system ".jxl_threads_test"
  end
end