class Bde < Formula
  desc "Basic Development Environment: foundational C++ libraries used at Bloomberg"
  homepage "https://github.com/bloomberg/bde"
  url "https://ghproxy.com/https://github.com/bloomberg/bde/archive/3.123.0.0.tar.gz"
  sha256 "17254dc8bedd081e18c118881df13bffe42b6175836f998e87cc27ea0c4d8949"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "1339d9b1c6d5d200e2976ffbbdcbf170205bcf365d871c06cdfb232e0dd219aa"
    sha256 cellar: :any,                 arm64_monterey: "8cf31eea8fe8b7339af8779b7c4d22e097e92bde46d3579293e22dd1cb3b25d0"
    sha256 cellar: :any,                 arm64_big_sur:  "a46ee4eb904081a33c898ae7a0aecf78a5b12a555681a7ca386d16665b572225"
    sha256 cellar: :any,                 ventura:        "1a8251173a88df9386233d8c13927aca254ccb57f96dcbf302873086bdacb542"
    sha256 cellar: :any,                 monterey:       "e1eb4806f33aa9d9866f0eeaa5dfa5cd9142d8430f300c2ebf01f1f1387e0f22"
    sha256 cellar: :any,                 big_sur:        "de9b109a18d344ae06dcf852b011e09ca07914b76b6d7ae4966b09f6cf2af550"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a5a1d5d353d6f8b2cc94a292b13c6226bf89689a7f11010191cf4a73d0c6a5f8"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.11" => :build
  depends_on "pcre2"

  resource "bde-tools" do
    url "https://ghproxy.com/https://github.com/bloomberg/bde-tools/archive/3.123.0.0.tar.gz"
    sha256 "9dac9d89e8485595a92db9d5464d5f54e487879382cd8dd708e20f5d022ca531"
  end

  def install
    (buildpath/"bde-tools").install resource("bde-tools")

    # Use brewed pcre2 instead of bundled sources
    inreplace "project.cmake", "${listDir}/thirdparty/pcre2\n", ""
    inreplace "groups/bdl/group/bdl.dep", "pcre2", "libpcre2-posix"
    inreplace "groups/bdl/bdlpcre/bdlpcre_regex.h", "#include <pcre2/pcre2.h>", "#include <pcre2.h>"

    toolchain_file = "bde-tools/cmake/toolchains/#{OS.kernel_name.downcase}/default.cmake"
    args = std_cmake_args + %W[
      -DBUILD_BITNESS=64
      -DUFID=opt_exc_mt_64_shr
      -DCMAKE_MODULE_PATH=./bde-tools/cmake
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DCMAKE_TOOLCHAIN_FILE=#{toolchain_file}
      -DPYTHON_EXECUTABLE=#{which("python3.11")}
    ]

    system "cmake", "-S", ".", "-B", "build", *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # CMake install step does not conform to FHS
    lib.install Dir[bin/"so/64/*"]
    lib.install lib/"opt_exc_mt_shr/cmake"
  end

  test do
    assert_equal version, resource("bde-tools").version, "`bde-tools` resource needs updating!"

    # bde tests are incredibly performance intensive
    # test below does a simple sanity check for linking against bsl.
    (testpath/"test.cpp").write <<~EOS
      #include <bsl_string.h>
      #include <bslma_default.h>
      int main() {
        using namespace BloombergLP;
        bsl::string string(bslma::Default::globalAllocator());
        return 0;
      }
    EOS
    system ENV.cxx, "-I#{include}", "test.cpp", "-L#{lib}", "-lbsl", "-o", "test"
    system "./test"
  end
end