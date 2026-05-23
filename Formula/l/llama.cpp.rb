class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://github.com/ggml-org/llama.cpp"
  # CMake uses Git to generate version information.
  url "https://github.com/ggml-org/llama.cpp.git",
      tag:      "b9290",
      revision: "bcfd1989e9a90af74669d94057ff2468682c3f4a"
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
    sha256 cellar: :any,                 arm64_tahoe:   "0ae69eeb8f0a29d979527c0814207691a8a00dcf343ff8bb5610ef2ae25c1e6f"
    sha256 cellar: :any,                 arm64_sequoia: "8dd0a89a6803bc0ea9ea016b4fdbbd0777383634a38f7841821d1e41219d5620"
    sha256 cellar: :any,                 arm64_sonoma:  "296bc877f013582fff2b530fdd7e4c174f7498ac4b5a11cb7f04dc831b14a6fa"
    sha256 cellar: :any,                 sonoma:        "ffffdc96a29133566425b0dd4d3bb1bc62979f22cc20b34beaac17f720a6854f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7db02bb1930ce8fe624935c2a2ab9c5b102b83ad8173b9d3cf9293db6b6a9f2c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e731e0587b487dfd644126173789a463bee15cfbef856eeaa8b10f03ca543564"
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