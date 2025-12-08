class Cppad < Formula
  desc "Differentiation of C++ Algorithms"
  homepage "https://cppad.readthedocs.io/latest/"
  url "https://ghfast.top/https://github.com/coin-or/CppAD/archive/refs/tags/20250000.3.tar.gz"
  sha256 "a3a4030ae49719e88e5057e923c4c97c5ba8910e22471f22661420ce65747fbe"
  license "EPL-2.0"
  version_scheme 1
  head "https://github.com/coin-or/CppAD.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c4ca96c223421fc69777fe2aea0bf71870cf0096ad35dfc4776a8dfbf04b8da2"
    sha256 cellar: :any,                 arm64_sequoia: "79b692e9389231c28284fbfc67f305fa34f6c48bbb9abd6fc280807d44e8cb39"
    sha256 cellar: :any,                 arm64_sonoma:  "07f62979a2d934260215b3a1723ff3510596bac8a2a03083280d1229205b9c0a"
    sha256 cellar: :any,                 sonoma:        "29a9228e0f99a231764248907ceb760a819c1b992c66c5224be6ccc8375dafd0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "916e3b757043c51a31262da4ada982ad4a9656f90c71ccf76974b575d185828e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1342ad344a8979c92aebd9a78c2e5c21fc7b470fd69f93abf45a2095c4acce1f"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build

  def install
    ENV.cxx11

    system "cmake", "-S", ".", "-B", "build", "-Dcppad_prefix=#{prefix}", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    pkgshare.install "example"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <cassert>
      #include <cppad/local/temp_file.hpp>
      #include <cppad/utility/thread_alloc.hpp>

      int main(void) {
        extern bool acos(void);
        bool ok = acos();
        assert(ok);
        return static_cast<int>(!ok);
      }
    CPP

    system ENV.cxx, "#{pkgshare}/example/general/acos.cpp", "-std=c++11", "-I#{include}",
                    "-L#{lib}", "-lcppad_lib",
                    "test.cpp", "-o", "test"
    system "./test"
  end
end