class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://llama.app"
  # CMake uses Git to generate version information.
  url "https://github.com/ggml-org/llama.cpp.git",
      tag:      "b9750",
      revision: "bf533823cd06e7fb21552265eee1bf2fd2752974"
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
    sha256 cellar: :any, arm64_tahoe:   "6c11d2e7e3c0fcad9e582cf8a7ead0005b534258735fb3e9c36ea9c5fb7ae68a"
    sha256 cellar: :any, arm64_sequoia: "dc03e6484275d7a98c5092c659432d481ccf1536b0629be724b44179d77f4e5a"
    sha256 cellar: :any, arm64_sonoma:  "8c1a8cd5afcee192a5c158a95865f3d7ac5313d1c518c44933c6a8c2c093b741"
    sha256 cellar: :any, sonoma:        "f972024fc14e54f053a718ad3deab8486a5c90f3626b976936c08f5eb017f659"
    sha256 cellar: :any, arm64_linux:   "3aea7d58a7ff2054f2bc958db8e3ad75b9ed5262333a5629e929dde47fc70a8e"
    sha256 cellar: :any, x86_64_linux:  "18add9383c8d3dae8da822a627c34ca830c34182b4ff245379d0270e2b3794c8"
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