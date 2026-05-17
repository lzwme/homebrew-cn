class Utf8cpp < Formula
  desc "UTF-8 with C++ in a Portable Way"
  homepage "https://github.com/nemtrif/utfcpp"
  url "https://ghfast.top/https://github.com/nemtrif/utfcpp/archive/refs/tags/v4.1.0.tar.gz"
  sha256 "9a45cbeefacf512879971eaf57fe52133b73a0152d5354f3adeaf8d103cff0f3"
  license "BSL-1.0"
  version_scheme 1
  compatibility_version 1

  bottle do
    sha256 cellar: :any_skip_relocation, all: "36d388fbfcaf87948e7117b33ea4e83b997628327fe7fc9541b24cd7b8715532"
  end

  depends_on "cmake" => [:build, :test]

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_match("PACKAGE_VERSION \"#{version}\"", (share/"utf8cpp/cmake/utf8cppConfigVersion.cmake").read)

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