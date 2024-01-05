class SpirvHeaders < Formula
  desc "Headers for SPIR-V"
  homepage "https:github.comKhronosGroupSPIRV-Headers"
  url "https:github.comKhronosGroupSPIRV-Headersarchiverefstagsvulkan-sdk-1.3.268.0.tar.gz"
  sha256 "1022379e5b920ae21ccfb5cb41e07b1c59352a18c3d3fdcbf38d6ae7733384d4"
  license "MIT"
  head "https:github.comKhronosGroupSPIRV-Headers.git", branch: "main"

  livecheck do
    url :stable
    regex(^(?:vulkan[._-])?sdk[._-]v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e8aff807e3b31c666941f26e3e9887b861861b4c679292966a34bb4af3034c5d"
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

    (testpath"CMakeLists.txt").write <<~EOS
      add_library(SPIRV-Headers-example
                  ${CMAKE_CURRENT_SOURCE_DIR}example.cpp)
      target_include_directories(SPIRV-Headers-example
                  PRIVATE ${SPIRV-Headers_SOURCE_DIR}include)
    EOS

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
  end
end