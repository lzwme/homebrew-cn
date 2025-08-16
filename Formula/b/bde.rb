class Bde < Formula
  desc "Basic Development Environment: foundational C++ libraries used at Bloomberg"
  homepage "https://github.com/bloomberg/bde"
  url "https://ghfast.top/https://github.com/bloomberg/bde/archive/refs/tags/4.28.0.0.tar.gz"
  sha256 "842b1ff2b5677886436cc537fd9ce2b68eb867be95024ee9a0f8ef1e1be78dfc"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f804a3c51a88e86137d31cbd399f0788926b699b18627b55c2524d24acf53762"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1f5d7aa66db39e19778d43af21a901e09d26e10f71261200f1aee58e2375791b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "995bc63d141057796a142343ac769aad34a90e530ef05bb34553b8ed2e2d3b5b"
    sha256 cellar: :any_skip_relocation, sonoma:        "9c98d3269316d9ff282aaea4c5f8b12cc9fc59f0b349d5b7dd118a4cfc1c38e0"
    sha256 cellar: :any_skip_relocation, ventura:       "dcb9c1c8189e7394b869161bb1c94680ee30d8a2aac17331344505b4f1226813"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6a033b25705d6e7447e60f582841944313ed172d1ee0cd7676e259b9e4bdafc3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fc3cb2ca3cc4176fdb6e929ae04afc5cabb87780387e77aa460c4f97d5863d9b"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "python@3.13" => :build
  depends_on "pcre2"

  resource "bde-tools" do
    url "https://ghfast.top/https://github.com/bloomberg/bde-tools/archive/refs/tags/4.27.0.0.tar.gz"
    sha256 "934c5f1599f1c4e05f82e20e610f78532aa37d9868311e7cfc39b789c48fa1b5"

    livecheck do
      regex(/^v?(\d+\.\d+\.\d+\.\d+)$/i)
    end
  end

  def install
    (buildpath/"bde-tools").install resource("bde-tools")

    # Use brewed pcre2 instead of bundled sources
    rm_r buildpath/"thirdparty/pcre2"
    inreplace "thirdparty/CMakeLists.txt", "add_subdirectory(pcre2)\n", ""
    inreplace "groups/bdl/group/bdl.dep", "pcre2", "libpcre2-posix"
    inreplace "groups/bdl/bdlpcre/bdlpcre_regex.h", "#include <pcre2/pcre2.h>", "#include <pcre2.h>"

    toolchain_file = "bde-tools/cmake/toolchains/#{OS.kernel_name.downcase}/default.cmake"
    args = %W[
      -DBUILD_BITNESS=64
      -DUFID=opt_exc_mt_64_shr
      -DCMAKE_MODULE_PATH=./bde-tools/cmake
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DCMAKE_TOOLCHAIN_FILE=#{toolchain_file}
      -DPYTHON_EXECUTABLE=#{which("python3.13")}
      -DBdeBuildSystem_DIR=#{buildpath}/bde-tools/BdeBuildSystem/
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    # bde tests are incredibly performance intensive
    # test below does a simple sanity check for linking against bsl.
    (testpath/"test.cpp").write <<~CPP
      #include <bsl_string.h>
      #include <bslma_default.h>
      int main() {
        using namespace BloombergLP;
        bsl::string string(bslma::Default::globalAllocator());
        return 0;
      }
    CPP
    system ENV.cxx, "-I#{include}", "test.cpp", "-L#{lib}", "-lbsl", "-o", "test"
    system "./test"
  end
end