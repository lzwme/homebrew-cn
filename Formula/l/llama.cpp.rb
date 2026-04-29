class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://github.com/ggml-org/llama.cpp"
  # CMake uses Git to generate version information.
  url "https://github.com/ggml-org/llama.cpp.git",
      tag:      "b8960",
      revision: "19821178be599edaf6a30d12efeaf835e7162995"
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
    sha256 cellar: :any,                 arm64_tahoe:   "c7ac393dfacd05e5c387bde61dba5aacf62596e7701b9f4adb021af35d3049e8"
    sha256 cellar: :any,                 arm64_sequoia: "c5faac167c83c8d60d4b7806d7b7ddcba0996511324efeb1379cb8984bd48412"
    sha256 cellar: :any,                 arm64_sonoma:  "b180e7c6d7f5c30c60ece2393291035694a410b01e5d85e759da40ed8c6271ab"
    sha256 cellar: :any,                 sonoma:        "22fa5299301c6bd496a7e89d2297969e4aed5646c544e966e5c4cd5369515aa4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "68b480bd1f0262dda52c99551baaf30e0db1f1bfc9949e0c85c32b5f947e271e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e30a2e872e18e24ce313ee778aa663fbcad8e535829a2d62f27bbc9ab9bf53dc"
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