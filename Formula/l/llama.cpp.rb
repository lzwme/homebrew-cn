class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://github.com/ggml-org/llama.cpp"
  # CMake uses Git to generate version information.
  url "https://github.com/ggml-org/llama.cpp.git",
      tag:      "b8990",
      revision: "660b1b4bdc6fedc18e8c3d87a945ffb51f91c547"
  license "MIT"
  compatibility_version 1
  head "https://github.com/ggml-org/llama.cpp.git", branch: "master"

  # llama.cpp publishes new tags too often
  # Having multiple updates in one day is not very convenient
  # Update formula only after 10 new tags (1 update per ≈2 days)
  #
  # `throttle 10` doesn't work
  livecheck do
    url :stable
    regex(/^v?b(\d+(?:\.\d+)*0)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "13d2d87612cf139d842d6462b86ae3a04fcbc6d9dd546776cfe22cd5c2ca4d0d"
    sha256 cellar: :any,                 arm64_sequoia: "a90fe81dcd1ee93c030c86bb764f80a374708b9fc9d1c8e1626fead9557f699e"
    sha256 cellar: :any,                 arm64_sonoma:  "7dc8794328fe746853dad613a3a871ef7b540958576a803c482edc5058775314"
    sha256 cellar: :any,                 sonoma:        "ae905f77011d57f4f299bbdcdd2520d981144a868f14069f1553c526670de3f1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "42450d3e5925de3fe6b03a4ce6026a27d58fbc917a09ac3ceb2ba3954ecede60"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "22e9ee3c8fe1231939927ce763bc373916cf8b15981d433fdb2fc4b2b59224e0"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "ggml" # NOTE: reject all PRs that try to bundle ggml
  depends_on "openssl@3"

  def install
    args = %W[
      -DBUILD_SHARED_LIBS=ON
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DLLAMA_ALL_WARNINGS=OFF
      -DLLAMA_BUILD_TESTS=OFF
      -DLLAMA_OPENSSL=ON
      -DLLAMA_USE_SYSTEM_GGML=ON
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    pkgshare.install "tests/test-sampling.cpp"
  end

  test do
    (testpath/"CMakeLists.txt").write <<~CMAKE
      cmake_minimum_required(VERSION 4.0)
      project(test LANGUAGES CXX)
      set(CMAKE_CXX_STANDARD 17)
      find_package(llama REQUIRED)
      add_executable(test-sampling #{pkgshare}/test-sampling.cpp)
      target_link_libraries(test-sampling PRIVATE llama)
    CMAKE

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "./build/test-sampling"

    # The test below is flaky on slower hardware.
    return if OS.mac? && Hardware::CPU.intel? && MacOS.version <= :monterey

    system bin/"llama-completion", "--hf-repo", "ggml-org/tiny-llamas",
                                   "-m", "stories260K.gguf",
                                   "-n", "400", "-p", "I", "-ngl", "0"
  end
end