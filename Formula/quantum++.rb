class Quantumxx < Formula
  desc "Modern C++ quantum computing library"
  homepage "https://github.com/softwareQinc/qpp"
  url "https://ghproxy.com/https://github.com/softwareQinc/qpp/archive/v4.2.tar.gz"
  sha256 "c466a1af0f7a8be82dbc8917a669bf9cef7aa88069b80f85dc0c233ef9fd6d56"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "8bd09168b0ea0b3e07ce918b681c30594331dbf7c55581549798385e3f27e33f"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "eigen"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"CMakeLists.txt").write <<~EOS
      cmake_minimum_required(VERSION 3.15)
      project(qpp_test)
      set(CMAKE_CXX_STANDARD 17)

      find_package(qpp REQUIRED)
      add_executable(qpp_test qpp_test.cpp)
      target_link_libraries(qpp_test PUBLIC ${QPP_LINK_DEPS} libqpp)
    EOS
    (testpath/"qpp_test.cpp").write <<~EOS
      #include <iostream>
      #include <qpp/qpp.h>

      int main() {
          using namespace qpp;
          std::cout << disp(transpose(0_ket)) << std::endl;
      }
    EOS
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    assert_equal "1  0", shell_output("./build/qpp_test").chomp
  end
end