class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://github.com/ggml-org/llama.cpp"
  # CMake uses Git to generate version information.
  url "https://github.com/ggml-org/llama.cpp.git",
      tag:      "b8610",
      revision: "2b86e5cae616c167b9c730c93138f26bba724adf"
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
    sha256 cellar: :any,                 arm64_tahoe:   "1e7b285999354cf613cf91f0237f14d09028da419c4b8c87c7940a12936d6a36"
    sha256 cellar: :any,                 arm64_sequoia: "42dfb3d51aef66beb306a5fff6574ac09fbd04e4ecfff69cdf7be172021094ff"
    sha256 cellar: :any,                 arm64_sonoma:  "5268d43449507ed9019b6c12baa406a75029edfd5b5d627a016864080c9805f4"
    sha256 cellar: :any,                 sonoma:        "e2c2e1e9aec363e47e19e88a5bf4a28a4066804531e0c4bf523f47bc16e134cb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "73361a09e22e24b2181ed44ea11c03e3b601910fb3ee7bf2b7d18461032dd890"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "650696c077a32a1f58d61c617cd3b8f740e556856e3e6bd825c912eb591ab0d2"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "ggml"
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