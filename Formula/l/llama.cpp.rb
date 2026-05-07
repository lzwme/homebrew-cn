class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://github.com/ggml-org/llama.cpp"
  # CMake uses Git to generate version information.
  url "https://github.com/ggml-org/llama.cpp.git",
      tag:      "b9030",
      revision: "a09a00e50259578ec0127d5116cb744191efeaac"
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
    sha256 cellar: :any,                 arm64_tahoe:   "1f0710fd78efb5d2beaefcaaa22b1afab8886618be2c330554a4d4cbf9d19334"
    sha256 cellar: :any,                 arm64_sequoia: "2c29cfe30aa3b9fe961ca06793a683e147a2f38272cad8c0e9a492295b106070"
    sha256 cellar: :any,                 arm64_sonoma:  "c3d5adcb4664b11b82272cdfb49ea8526df05f2601fea5e0a7663e4810c85c74"
    sha256 cellar: :any,                 sonoma:        "883cabbdbb0a360062cd4aea2bfab80dd579cfa55ec87c3893e0a264645a38e1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d4874c87003d342b40cd0c34a3d5534e6791b8a29bbf99a2a72ae8f2ea2f1c92"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f80efecbe8b017386c259900b49a00ccadd7b295b9ed269b27fc68005e0e32f9"
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