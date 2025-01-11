class Cppad < Formula
  desc "Differentiation of C++ Algorithms"
  homepage "https:www.coin-or.orgCppAD"
  url "https:github.comcoin-orCppADarchiverefstags20250000.0.tar.gz"
  sha256 "5439b4c972ed16f1583f2f41f20bd958019558506626b0e916a3e84bbf06cbc5"
  license "EPL-2.0"
  version_scheme 1
  head "https:github.comcoin-orCppAD.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "58ad44d410548276d640dcad04df297a7d67dc494514e1765df9280e9511d0a5"
    sha256 cellar: :any,                 arm64_sonoma:  "7f8b177e706210a4ebd86f4fc723187ee4a1c13b1fcc76709c27739efa086593"
    sha256 cellar: :any,                 arm64_ventura: "b1e5091aa457c79e72346df4bc8728dddf9ca8d85642d9819305ef34dfaa1ad4"
    sha256 cellar: :any,                 sonoma:        "b89f703e9b5149ff6e99a75e28f3c2df2b9046e3610123c1c80de5b0066f3679"
    sha256 cellar: :any,                 ventura:       "f8ad1c0b3f06557e5e9367d5c87003da38decb20646afa1699eb0062a1904344"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cf3e84f776409bd97c2001c0c6d213219737a6b3100cf2a0df55de558e20f46e"
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
    (testpath"test.cpp").write <<~CPP
      #include <cassert>
      #include <cppadlocaltemp_file.hpp>
      #include <cppadutilitythread_alloc.hpp>

      int main(void) {
        extern bool acos(void);
        bool ok = acos();
        assert(ok);
        return static_cast<int>(!ok);
      }
    CPP

    system ENV.cxx, "#{pkgshare}examplegeneralacos.cpp", "-std=c++11", "-I#{include}",
                    "-L#{lib}", "-lcppad_lib",
                    "test.cpp", "-o", "test"
    system ".test"
  end
end