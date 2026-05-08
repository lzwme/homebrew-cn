class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://github.com/ggml-org/llama.cpp"
  # CMake uses Git to generate version information.
  url "https://github.com/ggml-org/llama.cpp.git",
      tag:      "b9060",
      revision: "ad092246587b16299291056a78bf6f73f636f114"
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
    sha256 cellar: :any,                 arm64_tahoe:   "0fe688c7e47c26ef7cdfd9eb41a6d4d8e414ca0d0929c5083573d19541408591"
    sha256 cellar: :any,                 arm64_sequoia: "c0c2c10a9280d9d5d6458219b43382bb762f047e4c1e4a18e8312c09c4115fb6"
    sha256 cellar: :any,                 arm64_sonoma:  "8eaf8d00b3d3312ea9da56c2ff29c12ebcb1e2d02e2bfd84cf3cbef285ca5511"
    sha256 cellar: :any,                 sonoma:        "012b1a3d0b146a1ddc9aac526333cdb718cc58b60bdf9c9ba8753b5fa42c830b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b60dca07baa9551467ba656d16651374486a95aef8e66e2f3e47e7155a425f1c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "11549d46a6e872322379395ac80671d39cfd8bf1038ca54b769d277933a33d63"
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