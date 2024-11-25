class Kfr < Formula
  desc "Fast, modern C++ DSP framework"
  homepage "https:www.kfrlib.com"
  url "https:github.comkfrlibkfrarchiverefstags6.1.0.tar.gz"
  sha256 "551205da23b203daac176a2a76c628e3ad188b9b786e651294bf7ad3e72a9aaf"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "e2b90bb8eeed1586a4ddb259649cfdf9d3ddc7c6fb673091c148c48b414c10dd"
    sha256 cellar: :any,                 arm64_sonoma:  "d4bb2ef0204f17163c5440ffd5f44a0acdeb7eae6c191dc09e9d9c123cb55901"
    sha256 cellar: :any,                 arm64_ventura: "863dec37fae31ff209e81ad7f49c1ad2f76e8b4119adbc927b38e2a3f2b7a706"
    sha256 cellar: :any,                 sonoma:        "ccf89db453e421210c8cf28d37a2354cb331eed4d71798bc6a053dc80c56e5fa"
    sha256 cellar: :any,                 ventura:       "36b78619baf4f3dc46c1acb13f8ad61a65bef6d179b8aade845a3b3b3ac22e24"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "602c7b2176c4d59ad50e16f8a9b119d65021db376fb53c175cfaac34b90c8023"
  end

  depends_on "cmake" => :build

  def install
    args = []
    # C API requires some clang extensions.
    args << "-DKFR_ENABLE_CAPI_BUILD=ON" if ENV.compiler == :clang

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath"test.cpp").write <<~CPP
      #include <kfrio.hpp>

      using namespace kfr;

      int main() {
        println("Hello KFR!");
        return 0;
      }
    CPP

    system ENV.cxx, "test.cpp", "-std=c++17", "-I#{include}", "-L#{lib}", "-lkfr_io",
                    "-o", "test"
    assert_equal "Hello KFR!", shell_output(".test").chomp
  end
end