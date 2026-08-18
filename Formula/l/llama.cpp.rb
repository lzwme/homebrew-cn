class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://llama.app"
  # CMake uses Git to generate version information.
  url "https://github.com/ggml-org/llama.cpp.git",
      tag:      "b10470",
      revision: "34af94cd9ab277632e27caeec2d41de2fd091b31"
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
    sha256 cellar: :any, arm64_tahoe:   "263b0d0cff75f627412fcc83211250412bf4e04fa7ebaad7bcaebb9490320085"
    sha256 cellar: :any, arm64_sequoia: "154c597dd56728c3f724b421207499f291ec0834b23e7d1ddaccb4a70bb57cda"
    sha256 cellar: :any, arm64_sonoma:  "95c4164d65582b8dd3a388f93a407adb87b344f8f7f4847607cf5a167febf8f9"
    sha256 cellar: :any, sonoma:        "90b86607be4c063ec9b33693afaa636ce5429976533763d44b30cd34f522e604"
    sha256 cellar: :any, arm64_linux:   "e2f5c991e19aafb7c7059d42ace823b6736aa817248e8c3f03a61ef8febb1c56"
    sha256 cellar: :any, x86_64_linux:  "53e217e09af829f3fd0839e5aa89612e56fefc48681a51b3a2203b0ba19bad35"
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

    assert_match "Available commands", shell_output("#{bin}/llama 2>&1")

    # The test below is flaky on slower hardware.
    return if OS.mac? && Hardware::CPU.intel? && MacOS.version <= :monterey

    system bin/"llama-completion", "--hf-repo", "ggml-org/tiny-llamas",
                                   "-m", "stories260K.gguf",
                                   "-n", "400", "-p", "I", "-ngl", "0"
  end
end