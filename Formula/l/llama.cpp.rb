class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://github.com/ggml-org/llama.cpp"
  # CMake uses Git to generate version information.
  url "https://github.com/ggml-org/llama.cpp.git",
      tag:      "b8400",
      revision: "cf23ee244717b7b41f092410991d0344b25620ea"
  license "MIT"
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
    sha256 cellar: :any,                 arm64_tahoe:   "becc31b6e04df151306f297d948cc3eb3fd60a92289c647f40f84b6e6ed004f9"
    sha256 cellar: :any,                 arm64_sequoia: "ba94be2b173844412211266dae0b32fe0912f87433c52044e05cfa6bb2bd1311"
    sha256 cellar: :any,                 arm64_sonoma:  "054da5b7ef6fed12102b08a0f4a330c1731e392ffc1b6c63288538c069c51b55"
    sha256 cellar: :any,                 sonoma:        "11f51abcf5d411ef36f56475dd743860005205f3199ae1b1725e8a39249d26b5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e675e1216d741ac751766d2e3d21855b0256b6a06a0b02cf1fcffe57f024a41b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a3164e1683e97791aa7db96ab8ddf89e95ac94be3d13b42763b61b4afdd921c0"
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