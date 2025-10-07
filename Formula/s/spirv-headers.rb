class SpirvHeaders < Formula
  desc "Headers for SPIR-V"
  homepage "https://github.com/KhronosGroup/SPIRV-Headers"
  url "https://ghfast.top/https://github.com/KhronosGroup/SPIRV-Headers/archive/refs/tags/vulkan-sdk-1.4.328.0.tar.gz"
  sha256 "00284a33e1e19014723c8e88ca7a16e8988cd23f839ec2b7da6bb1808fd2a751"
  license "MIT"
  head "https://github.com/KhronosGroup/SPIRV-Headers.git", branch: "main"

  livecheck do
    url :stable
    regex(/^(?:vulkan[._-])?sdk[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "08b5aacc80b49db11884168adda5a0eeb807f252e6c059dbe045e24afe39469a"
  end

  depends_on "cmake" => [:build, :test]

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    pkgshare.install "tests"
  end

  test do
    cp pkgshare/"tests/example.cpp", testpath

    (testpath/"CMakeLists.txt").write <<~CMAKE
      cmake_minimum_required(VERSION 3.14)

      add_library(SPIRV-Headers-example
                  ${CMAKE_CURRENT_SOURCE_DIR}/example.cpp)
      target_include_directories(SPIRV-Headers-example
                  PRIVATE ${SPIRV-Headers_SOURCE_DIR}/include)
    CMAKE

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
  end
end