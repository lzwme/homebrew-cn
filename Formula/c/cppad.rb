class Cppad < Formula
  desc "Differentiation of C++ Algorithms"
  homepage "https:www.coin-or.orgCppAD"
  url "https:github.comcoin-orCppADarchiverefstags20240000.1.tar.gz"
  sha256 "2ccdf1e7ed172ba256a4bf8809b8df3d1389b5f71f47385340882985feef017f"
  license "EPL-2.0"
  version_scheme 1
  head "https:github.comcoin-orCppAD.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "3a98dabdd8a5a40d4b26772ebe7e4672b9810543393f4e141d82781e3d9dfeb3"
    sha256 cellar: :any,                 arm64_ventura:  "a59ccdf1498370f94ed7af26ffd0f8cf7391b0cad6d277194d7b8b6665ca524f"
    sha256 cellar: :any,                 arm64_monterey: "bd1fbcc04d5312ce787056671932acf318a444a79818c5bba97521111d1c9096"
    sha256 cellar: :any,                 sonoma:         "e6eeca85e63b6b6258a1071612e9e494d3a97848a11aad0fb725a15d6885f582"
    sha256 cellar: :any,                 ventura:        "d3ece13f66234ff18104e1d52574d7107ba392b2ee3db7151cfc0d5e1311ba0d"
    sha256 cellar: :any,                 monterey:       "e4cf0723d71c3420eefeebad1af61e7957cdee179adeb5f0f99588b83ab82b84"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f8ab7bb27486200ae0f1c935a22d735b6d2f89802a388c18d320b71b07158cdc"
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