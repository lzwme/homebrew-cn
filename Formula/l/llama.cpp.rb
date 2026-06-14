class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://github.com/ggml-org/llama.cpp"
  # CMake uses Git to generate version information.
  url "https://github.com/ggml-org/llama.cpp.git",
      tag:      "b9620",
      revision: "57fe1f07c3b6a1de3f4fff19098e2056a85275b7"
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
    sha256 cellar: :any, arm64_tahoe:   "4b0f1b48f5d86a51e0ac3c9028d7bb84286e52ca1540ac4e6fef125e02d4b95f"
    sha256 cellar: :any, arm64_sequoia: "ca9ecc88d04ee6618169fda3f0b3641f7f14a759321399d43de858f668a61e0e"
    sha256 cellar: :any, arm64_sonoma:  "d1b498a772cc55921267a0bfbd28537c67d70ac305fc4abac63d6b86346c12c1"
    sha256 cellar: :any, sonoma:        "39fb61becfc83ed231ee1c1f59e7a22e32e4abd72fe7f6a53115972a6c529637"
    sha256 cellar: :any, arm64_linux:   "04a29318b8095ba1abe7e901bfff05cec1c9867cc193b282f713127b18304fef"
    sha256 cellar: :any, x86_64_linux:  "4b4690f1f0df890dd7e39f48065bb8d1517c224b533864ac4ba8005f94e17180"
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