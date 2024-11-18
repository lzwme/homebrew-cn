class Bde < Formula
  desc "Basic Development Environment: foundational C++ libraries used at Bloomberg"
  homepage "https:github.combloombergbde"
  url "https:github.combloombergbdearchiverefstags4.16.1.0.tar.gz"
  sha256 "32bb1912b6c37b11ca86c87a7295adeca928ef816014926da089088e5a843d6d"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "934e52e46f5efff74a846378b931dda85b21d0a47039fdc7e362445a28a6d568"
    sha256 cellar: :any,                 arm64_sonoma:  "eee9621db68ba4e039acac1b384be033bf779f8b17856b61a220ea05ef63da47"
    sha256 cellar: :any,                 arm64_ventura: "292257df4ef9f7e16098a88b4149a0882caaf45b9df07a24926c24773b169976"
    sha256 cellar: :any,                 sonoma:        "42cd88a057de2e123e710f8e42c8ad636d82650d48e52cec020b3fe27fb3600d"
    sha256 cellar: :any,                 ventura:       "659df6906e225ca217ceebff0f469712f8fe83eb7d012e8de0e945a59a93f7ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "87dcfaea08789f78092daf1658160f1ac5806bc42ee5b76308898c1b9ba8ba2a"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "python@3.13" => :build
  depends_on "pcre2"

  resource "bde-tools" do
    url "https:github.combloombergbde-toolsarchiverefstags4.13.0.0.tar.gz"
    sha256 "d70ab85eb1a4325f3d569a6b7ea0f0a44a6143fd91905ab5fbaa5e1fed111a68"
  end

  def install
    (buildpath"bde-tools").install resource("bde-tools")

    # Use brewed pcre2 instead of bundled sources
    rm_r buildpath"thirdpartypcre2"
    inreplace "project.cmake", "${listDir}thirdpartypcre2\n", ""
    inreplace "groupsbdlgroupbdl.dep", "pcre2", "libpcre2-posix"
    inreplace "groupsbdlbdlpcrebdlpcre_regex.h", "#include <pcre2pcre2.h>", "#include <pcre2.h>"

    toolchain_file = "bde-toolscmaketoolchains#{OS.kernel_name.downcase}default.cmake"
    args = %W[
      -DBUILD_BITNESS=64
      -DUFID=opt_exc_mt_64_shr
      -DCMAKE_MODULE_PATH=.bde-toolscmake
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DCMAKE_TOOLCHAIN_FILE=#{toolchain_file}
      -DPYTHON_EXECUTABLE=#{which("python3.13")}
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # CMake install step does not conform to FHS
    lib.install Dir[bin"so64*"]
    lib.install lib"opt_exc_mt_shrcmake"
  end

  test do
    # bde tests are incredibly performance intensive
    # test below does a simple sanity check for linking against bsl.
    (testpath"test.cpp").write <<~CPP
      #include <bsl_string.h>
      #include <bslma_default.h>
      int main() {
        using namespace BloombergLP;
        bsl::string string(bslma::Default::globalAllocator());
        return 0;
      }
    CPP
    system ENV.cxx, "-I#{include}", "test.cpp", "-L#{lib}", "-lbsl", "-o", "test"
    system ".test"
  end
end