class Cppad < Formula
  desc "Differentiation of C++ Algorithms"
  homepage "https:www.coin-or.orgCppAD"
  url "https:github.comcoin-orCppADarchiverefstags20240000.6.tar.gz"
  sha256 "10442c13eda016eef9b55d623efc28442c002b8d8b0bada52f3fbc3135f3cab3"
  license "EPL-2.0"
  version_scheme 1
  head "https:github.comcoin-orCppAD.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "b30a59deef462ba5062b0b06af07e027b619d2402a81029595dd903ac9ad8ec4"
    sha256 cellar: :any,                 arm64_ventura:  "e7619da89cfe4a228408869810181c7a3e2ee5f0c02994f983d8008baaa7c897"
    sha256 cellar: :any,                 arm64_monterey: "6726468a0c6a38dd4d426dd004080ed6b1a86765f912afc9a9f962cace5fe225"
    sha256 cellar: :any,                 sonoma:         "e18001444640ab842cca4e720730690db22555606639f3b8f52c1ff290e52407"
    sha256 cellar: :any,                 ventura:        "b8e7c1b0886a93444c8084206988b3e6bd4672cbaccfa4f1d274ef5f12e2644d"
    sha256 cellar: :any,                 monterey:       "71bb4474d8e070217e04371449bcb28c92774d773f60c7ffdccc10cd3385770b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fdacda516703d0465e90afa9e23bc236194700c6a1bed54f48dcaf25265bca29"
  end

  depends_on "cmake" => :build

  def install
    ENV.cxx11

    system "cmake", "-S", ".", "-B", "build", "-Dcppad_prefix=#{prefix}", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    pkgshare.install "example"
  end

  test do
    (testpath"test.cpp").write <<~EOS
      #include <cassert>
      #include <cppadlocaltemp_file.hpp>
      #include <cppadutilitythread_alloc.hpp>

      int main(void) {
        extern bool acos(void);
        bool ok = acos();
        assert(ok);
        return static_cast<int>(!ok);
      }
    EOS

    system ENV.cxx, "#{pkgshare}examplegeneralacos.cpp", "-std=c++11", "-I#{include}",
                    "-L#{lib}", "-lcppad_lib",
                    "test.cpp", "-o", "test"
    system ".test"
  end
end