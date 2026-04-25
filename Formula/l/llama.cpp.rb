class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://github.com/ggml-org/llama.cpp"
  # CMake uses Git to generate version information.
  url "https://github.com/ggml-org/llama.cpp.git",
      tag:      "b8920",
      revision: "15fa3c493bfcd040b5f4dcb29e1c998a0846de16"
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
    sha256 cellar: :any,                 arm64_tahoe:   "0a862799388724fb3f4f0305fd0d3d4557f99b2329e5ad3511cc0c99761e2481"
    sha256 cellar: :any,                 arm64_sequoia: "04556be10e8102868b66780590de11b4da40673ab30a59fbfc791df91d2b6469"
    sha256 cellar: :any,                 arm64_sonoma:  "e98f1be3972d6edc48fd8b88edce3291b05ec161ed7d5dd05fa0cdc4b71249e8"
    sha256 cellar: :any,                 sonoma:        "aab291fde6211f575378c38183c7240e89bc4053728f38f315e2ce5a1cb9a880"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f7728d2e9416c2e27ae9989db4bbdf0cdd465d9ba55d1ac0be515db9de083f52"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3aa980cda89924f66f7ef7b95fb6f5af79ad8be5fd942a19a5dfb763618f24b2"
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