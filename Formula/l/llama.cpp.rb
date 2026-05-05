class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://github.com/ggml-org/llama.cpp"
  # CMake uses Git to generate version information.
  url "https://github.com/ggml-org/llama.cpp.git",
      tag:      "b9020",
      revision: "a4701c98f72160144b101090596c7ea1ef0c1d7b"
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
    sha256 cellar: :any,                 arm64_tahoe:   "a53cea5b0fc0cbe8d2ba19f1f4fdb28d992457daee238c403ead31c524eba316"
    sha256 cellar: :any,                 arm64_sequoia: "3bac583169ba0cfb326269bfb8038d46160793fac1b45e7d60d4442e0bcf17c2"
    sha256 cellar: :any,                 arm64_sonoma:  "b1cd9986b38774fa69d62c615544755a08701fdb2eb044714beea9f6e497fd4c"
    sha256 cellar: :any,                 sonoma:        "4903ade2a8d4529adb4d00577fa8b0077f9517cb59d1d842a0fd8ac7c0fab45a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "76af8e0a94deaf23479bc0d41bdf9f368a55f90a7c52f03a6828a573d0561599"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9554562c3cf639e0a4b45576bb57f43b86d2e9a97cdef61a58ba817c349dce76"
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