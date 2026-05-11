class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://github.com/ggml-org/llama.cpp"
  # CMake uses Git to generate version information.
  url "https://github.com/ggml-org/llama.cpp.git",
      tag:      "b9100",
      revision: "2e97c5f96f9fe2bb26f794a348e05d7a1c74baa1"
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
    sha256 cellar: :any,                 arm64_tahoe:   "4c52b5be83eb3153b875182f6d35c06b1a1864865a89189486a0f075b94bdee0"
    sha256 cellar: :any,                 arm64_sequoia: "dbdc2cf7339588b42a1c880bef6d7b888fad091682fc3bbb52987ca3fda76c17"
    sha256 cellar: :any,                 arm64_sonoma:  "853dc8a410f94fa570ecea3028411ebda905f0382680686d7dffd9765f7eff49"
    sha256 cellar: :any,                 sonoma:        "341746155c734ba03b44d6675abd47b5d2b75b561a48e50b2e2b6bccf8bc5217"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e4c1cfdafc30d5e7b684aae99cc9c274a0a8fdc72ffa86031808c74750b5eb5f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d76dc2b42a0b290ad4d6d0ba38abbd0819ef28a774c5033abad0c779a265a1b5"
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