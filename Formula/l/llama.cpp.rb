class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://github.com/ggml-org/llama.cpp"
  # CMake uses Git to generate version information.
  url "https://github.com/ggml-org/llama.cpp.git",
      tag:      "b9270",
      revision: "7ea23ddf7b7cb57e37275774f2d4b718db5c5c26"
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
    sha256 cellar: :any,                 arm64_tahoe:   "ae77fd5cb4164b9a8d7f94720aeb2c669470d9af9ced4b231c9d5b3867c190c5"
    sha256 cellar: :any,                 arm64_sequoia: "8debe0e35f23d6579d98dd83a08b05f9c0da00bdb9e4b67caae2ea3940246d7f"
    sha256 cellar: :any,                 arm64_sonoma:  "ee81ddd3576f440f49c785d55ceae425ea2175ba34c2b065a430fc4a66a59e60"
    sha256 cellar: :any,                 sonoma:        "67044487701cbca52c25aa6c536130977cfdb282fafb3225ef68958ab5ab787d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a0797caf49e9f55aa26a7aeaa80246a64fac8927f25d5c3309a270f51d46fc1b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "10ad8b3e5be976585d33d1c512c516900c2c3c3cd020f8f6be3f62671ecb055d"
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