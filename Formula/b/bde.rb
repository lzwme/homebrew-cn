class Bde < Formula
  desc "Basic Development Environment: foundational C++ libraries used at Bloomberg"
  homepage "https://github.com/bloomberg/bde"
  url "https://ghfast.top/https://github.com/bloomberg/bde/archive/refs/tags/4.30.0.0.tar.gz"
  sha256 "4d7aec410a35e58cd3ccd302aeccbfdaf8ae2a0b954b3efbb47c3cf6cd241015"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "954db5129ad62c9720463e06000bb26ff2a24e85637544fbd37d9f7ea750f423"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d6ddd0e431981855ee0e1551d35889c99f6a24cf9f395e4212403ad4bd4484d6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "83ba6dd416b42c4c7ad1db53b861d58963871e2cb8f5cd150e8d3f814b92faea"
    sha256 cellar: :any_skip_relocation, sonoma:        "95f4f7a753dd45cb1ec5c7bb21b535daaf413cee1011f52f7ffabc9ba950e588"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f0369cc9bae5ed399ffcd2efb1e4474052cb88a28355a455a96c6e492e5a3e46"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0a2a344b2294ffcf3f5416a6a4f188dfdba8add2f9501a51a99be4629d578c94"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "python@3.14" => :build
  depends_on "pcre2"

  resource "bde-tools" do
    url "https://ghfast.top/https://github.com/bloomberg/bde-tools/archive/refs/tags/4.29.0.0.tar.gz"
    sha256 "0e9fb2871cf0df9df2d86c240d736e94f47de67de4ccfeacb1f03e4a6a1f3a09"

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
      -DPYTHON_EXECUTABLE=#{which("python3.14")}
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