class Bde < Formula
  desc "Basic Development Environment: foundational C++ libraries used at Bloomberg"
  homepage "https:github.combloombergbde"
  url "https:github.combloombergbdearchiverefstags4.14.0.0.tar.gz"
  sha256 "b6dbc5438b666b15548192e2faf9bf80305c1a63aec45182bf8838084521fdb1"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "7f67faec9de552083dcac23a3f0a7a0c6e2adb42e85770c22951267f6e2e9afb"
    sha256 cellar: :any,                 arm64_sonoma:  "277f78608b4582deeb39ca4c5b39d79c799a260f0e2eb7f14ae35d57935923b8"
    sha256 cellar: :any,                 arm64_ventura: "48d694b6d2670efc233881b41df93a283922bb7fb90cac30da84ac3ccbdfe8a8"
    sha256 cellar: :any,                 sonoma:        "6f328ffe113ee3350f6751ab0950a5557c2a7e3464e1e9a70c35d4c2d15cbace"
    sha256 cellar: :any,                 ventura:       "8fdbc779c7b07a9116f55fb154c829683a8fcd7de5eb1fabd2f36be19d1b1579"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5efd48ad8ab44e4e14c3caf011e74e6269e11a915e094ea6479b84a26359732c"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.12" => :build
  depends_on "pcre2"

  resource "bde-tools" do
    url "https:github.combloombergbde-toolsarchiverefstags4.8.0.0.tar.gz"
    sha256 "49fdfb3a3e2c4803ba8a9bfa680cb50943c41ef1e6b1725087b877557b82bd35"
  end

  def install
    # TODO: `bde-tools` did not have a matching tag for 4.14.0.0. Check if it's in sync again in the next release.
    # odie "bde-tools resource needs to be updated" if version != resource("bde-tools").version
    odie "Check if bde-tools resource version is in sync again" if version > "4.14.0.0"

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
      -DPYTHON_EXECUTABLE=#{which("python3.12")}
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
    (testpath"test.cpp").write <<~EOS
      #include <bsl_string.h>
      #include <bslma_default.h>
      int main() {
        using namespace BloombergLP;
        bsl::string string(bslma::Default::globalAllocator());
        return 0;
      }
    EOS
    system ENV.cxx, "-I#{include}", "test.cpp", "-L#{lib}", "-lbsl", "-o", "test"
    system ".test"
  end
end