class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://github.com/ggml-org/llama.cpp"
  # CMake uses Git to generate version information.
  url "https://github.com/ggml-org/llama.cpp.git",
      tag:      "b9370",
      revision: "aa50b2c2ae91326d5aad956ceeb015d1d48e626b"
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
    sha256 cellar: :any,                 arm64_tahoe:   "c1b6d0ae96c89192281a59a5bd154a379f1a42087347ebdf5d93e3826a5af27b"
    sha256 cellar: :any,                 arm64_sequoia: "7af2a497d784e35f992539c7f796a6eb3a645c6888fcbb0d3dcc055baec50943"
    sha256 cellar: :any,                 arm64_sonoma:  "a56e34173caa7ef4b1a1da9a67771e4fac15802cb7750dea4a6accd00f22066e"
    sha256 cellar: :any,                 sonoma:        "2548196fcc84c9f55097a0a64d159e856d3113cec83f9e7a4027f41c1802730d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fa6eadb49bdb9355ec8713c7cd278c48757715a4299e40e48e6c80ca3e6699b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "df56e49d5c5ae48193d03e5ba136dd5629994530c3c20fe3b0d8cb7ddd18e080"
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