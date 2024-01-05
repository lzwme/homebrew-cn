class Cppad < Formula
  desc "Differentiation of C++ Algorithms"
  homepage "https:www.coin-or.orgCppAD"
  url "https:github.comcoin-orCppADarchiverefstags20240000.0.tar.gz"
  sha256 "feda4e3580d4dcbf327be3d2d355e85eb25de08b64d68c68503365767ec93af1"
  license "EPL-2.0"
  version_scheme 1
  head "https:github.comcoin-orCppAD.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "8a0ea744921a08721da7675172a6c65bc50fe62685f001627491eb4a0d7e8a5a"
    sha256 cellar: :any,                 arm64_ventura:  "178c9ecd276df14da123d82417c309af8bd82d2e772a5ad5b43384a63c7ac005"
    sha256 cellar: :any,                 arm64_monterey: "91be68cf63d262f25b575ae076bf2ca719e3a6ea5b63d16aba0b134e816e9fef"
    sha256 cellar: :any,                 sonoma:         "712e55886fd2f8c0ecd1c7ee235c98323ddbc94b083a471d8035093d66ade56c"
    sha256 cellar: :any,                 ventura:        "589a8e4b235d8919fbafc36807129472c057e071bdf24edd13f6a0c592b7757d"
    sha256 cellar: :any,                 monterey:       "a2eeb3b45818bcfce1c20764bc6625f5cd6201bcab4b26f6404ff4dd6ab095c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eed3cc65022becf019aa85966f11d8393986fff2dcd20e30c318d0a8ead4c845"
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