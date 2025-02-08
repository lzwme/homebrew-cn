class SpirvHeaders < Formula
  desc "Headers for SPIR-V"
  homepage "https:github.comKhronosGroupSPIRV-Headers"
  url "https:github.comKhronosGroupSPIRV-Headersarchiverefstagsvulkan-sdk-1.4.304.1.tar.gz"
  sha256 "66e6cec19e7433fc58ace8cdf4040be0d52bb5920e54109967df2dd9598a8d48"
  license "MIT"
  head "https:github.comKhronosGroupSPIRV-Headers.git", branch: "main"

  livecheck do
    url :stable
    regex(^(?:vulkan[._-])?sdk[._-]v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "640f9abece687c2097b07c3e673968e79f57002f8022212fcee19cfa23708dc4"
  end

  depends_on "cmake" => [:build, :test]

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    pkgshare.install "tests"
  end

  test do
    cp pkgshare"testsexample.cpp", testpath

    (testpath"CMakeLists.txt").write <<~CMAKE
      cmake_minimum_required(VERSION 3.14)

      add_library(SPIRV-Headers-example
                  ${CMAKE_CURRENT_SOURCE_DIR}example.cpp)
      target_include_directories(SPIRV-Headers-example
                  PRIVATE ${SPIRV-Headers_SOURCE_DIR}include)
    CMAKE

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
  end
end