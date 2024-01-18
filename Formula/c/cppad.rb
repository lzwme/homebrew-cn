class Cppad < Formula
  desc "Differentiation of C++ Algorithms"
  homepage "https:www.coin-or.orgCppAD"
  url "https:github.comcoin-orCppADarchiverefstags20240000.2.tar.gz"
  sha256 "859fb76168fa96d18609fe41b15ccab43a7ca4db0022ea5de526a559f735b05c"
  license "EPL-2.0"
  version_scheme 1
  head "https:github.comcoin-orCppAD.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "d12c2a7d18b01ef9fdce995d7ad034a7c821769e1ca7ab98b8d5cf540c98ea71"
    sha256 cellar: :any,                 arm64_ventura:  "15fb093bbccc84db7e902b534582684b962ecd481de643766945fdd737d19f52"
    sha256 cellar: :any,                 arm64_monterey: "d81c8146226b83f6861652396ccd6667b899c259824d63d70cb14725e9034ecc"
    sha256 cellar: :any,                 sonoma:         "24be243a61a0a0f00ccded8f8726b2f73cfb2faf49abf9456fb3be69c97d79ce"
    sha256 cellar: :any,                 ventura:        "de6e377bbaf59b8655b0d205ccde4f1f39b5f0cbaba3f4266e2d7d9398e5c453"
    sha256 cellar: :any,                 monterey:       "58f2809811a75b3392fdb38dc6e4b577e772ca735d906b9fb21cc0fa5e0461ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a990029f406085153495d9474210ddf3f7cbba17c46f21e607179383fda6d256"
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