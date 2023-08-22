class SpirvHeaders < Formula
  desc "Headers for SPIR-V"
  homepage "https://github.com/KhronosGroup/SPIRV-Headers"
  url "https://ghproxy.com/https://github.com/KhronosGroup/SPIRV-Headers/archive/refs/tags/sdk-1.3.261.0.tar.gz"
  sha256 "846d60811fb696b517e1e30073320f4e12572be57f1f4c9572843f87f2d07f81"
  license "MIT"
  head "https://github.com/KhronosGroup/SPIRV-Headers.git", branch: "main"

  livecheck do
    url :stable
    regex(/^sdk[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "3573f6c5ae558e5b2756a3620fe15b29edd5e10cd62fc749b18bf1c4ec1d035c"
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

    (testpath/"CMakeLists.txt").write <<~EOS
      add_library(SPIRV-Headers-example
                  ${CMAKE_CURRENT_SOURCE_DIR}/example.cpp)
      target_include_directories(SPIRV-Headers-example
                  PRIVATE ${SPIRV-Headers_SOURCE_DIR}/include)
    EOS

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
  end
end