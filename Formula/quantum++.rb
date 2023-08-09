class Quantumxx < Formula
  desc "Modern C++ quantum computing library"
  homepage "https://github.com/softwareQinc/qpp"
  url "https://ghproxy.com/https://github.com/softwareQinc/qpp/archive/v4.3.3.tar.gz"
  sha256 "8a43ea7f1a3d1679016ad04cbbfb079284efdc6048784d126f7b04481d573958"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "b8b7a332f7a1f094fc3d86666a91cc4c670e58aa252fd5c4c6d39bbb65f4f419"
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