class Quantumxx < Formula
  desc "Modern C++ quantum computing library"
  homepage "https:github.comsoftwareQincqpp"
  url "https:github.comsoftwareQincqpparchiverefstagsv6.0.tar.gz"
  sha256 "cdd6acf287b2f2dd124120ef2aba85660eee9482f5484dbd229c93b53a7d8a54"
  license "MIT"
  head "https:github.comsoftwareQincqpp.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "13832215cff599c6d60a58a3c40d0206d3f1082c0c42f1a8b9ee2a3c49087be8"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "googletest" => :build
  depends_on "eigen"
  depends_on "pybind11"

  def install
    args = %w[
      -DFETCHCONTENT_FULLY_DISCONNECTED=OFF
      -DHOMEBREW_ALLOW_FETCHCONTENT=ON
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build", "--target", "install"
  end

  test do
    (testpath"CMakeLists.txt").write <<~CMAKE
      cmake_minimum_required(VERSION 3.15)
      project(qpp_test)
      set(CMAKE_CXX_STANDARD 17)

      find_package(qpp REQUIRED)
      add_executable(qpp_test qpp_test.cpp)
      target_link_libraries(qpp_test PUBLIC ${QPP_LINK_DEPS} libqpp)
    CMAKE
    (testpath"qpp_test.cpp").write <<~CPP
      #include <iostream>
      #include <qppqpp.hpp>

      int main() {
          using namespace qpp;
          std::cout << disp(transpose(0_ket)) << std::endl;
      }
    CPP
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    assert_equal "1  0", shell_output(".buildqpp_test").chomp
  end
end