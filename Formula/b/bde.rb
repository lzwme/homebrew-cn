class Bde < Formula
  desc "Basic Development Environment: foundational C++ libraries used at Bloomberg"
  homepage "https:github.combloombergbde"
  url "https:github.combloombergbdearchiverefstags4.22.0.0.tar.gz"
  sha256 "949241697e90f12204aaa25e55612869c5c7baa55d1e5ee9f4ccd610ed9c95c1"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9f4b28f534db88ae552706e799de016f1657ac7e69469b855d67c89b011c875f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "433da5a2dc63ffe51564ad1e09e5e94496e833627fe02cd61a7d3ce6ea931d68"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "11c72d8ae4484b3dd6afc872c5efc96c8674aa4650e2946847f351ba1e0da563"
    sha256 cellar: :any_skip_relocation, sonoma:        "36c215557f23a0502ac98a4144718f27a59477de60e9539964003388adf8fd03"
    sha256 cellar: :any_skip_relocation, ventura:       "bfce401b93ad5dbd14c38e695c4577a829acb7c7d50e5acd0da57eb2461b38d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1caf379e74c4e79db636965d13b60e2a7d29dce9ea1e99d10b794588aad39011"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "python@3.13" => :build
  depends_on "pcre2"

  resource "bde-tools" do
    url "https:github.combloombergbde-toolsarchiverefstags4.22.0.0.tar.gz"
    sha256 "14e46ebb12f15d4a97b2d6967bc98780af77b97f5904a86203b43028c3587944"

    livecheck do
      formula :parent
    end
  end

  def install
    (buildpath"bde-tools").install resource("bde-tools")

    # Use brewed pcre2 instead of bundled sources
    rm_r buildpath"thirdpartypcre2"
    inreplace "thirdpartyCMakeLists.txt", "add_subdirectory(pcre2)\n", ""
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
      -DBdeBuildSystem_DIR=#{buildpath}bde-toolsBdeBuildSystem
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
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