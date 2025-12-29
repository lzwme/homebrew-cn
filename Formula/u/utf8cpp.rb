class Utf8cpp < Formula
  desc "UTF-8 with C++ in a Portable Way"
  homepage "https://github.com/nemtrif/utfcpp"
  url "https://ghfast.top/https://github.com/nemtrif/utfcpp/archive/refs/tags/v4.09.tar.gz"
  sha256 "0902218f606e942ccc10724df8a988fc993c12da4b3adeace28a7f0211970e08"
  license "BSL-1.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "68e034076d7c7bafa63e645d0779ab2c01efe283217f0d09edaea21f6541e3fc"
  end

  depends_on "cmake" => [:build, :test]

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"CMakeLists.txt").write <<~CMAKE
      cmake_minimum_required(VERSION 4.0 FATAL_ERROR)
      project(utf8_append LANGUAGES CXX)
      find_package(utf8cpp REQUIRED CONFIG)
      add_executable(utf8_append utf8_append.cpp)
    CMAKE

    (testpath/"utf8_append.cpp").write <<~CPP
      #include <utf8cpp/utf8.h>
      int main() {
        unsigned char u[5] = {0, 0, 0, 0, 0};
        utf8::append(0x0448, u);
        return (u[0] == 0xd1 && u[1] == 0x88 && u[2] == 0 && u[3] == 0 && u[4] == 0) ? 0 : 1;
      }
    CPP

    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_PREFIX_PATH=#{opt_lib}", "-DCMAKE_VERBOSE_MAKEFILE=ON"
    system "cmake", "--build", "build"
    system "./build/utf8_append"
  end
end