class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://github.com/ggml-org/llama.cpp"
  # CMake uses Git to generate version information.
  url "https://github.com/ggml-org/llama.cpp.git",
      tag:      "b8640",
      revision: "7992aa7c8e21ea2eb7a5e4802da56eec7b376036"
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
    sha256 cellar: :any,                 arm64_tahoe:   "e69794e43a7fe982d4fba15a75b95a5f7d74420f54a0939af3f6ba19251312d9"
    sha256 cellar: :any,                 arm64_sequoia: "0f8422714b29a677e99ad2c3d4f949f49f20b01dd05f8a889f341f4a39862f08"
    sha256 cellar: :any,                 arm64_sonoma:  "f6c4bb47b975c993d463d54f49e09d24bd670144b4b79e6c66888ccea104a5a1"
    sha256 cellar: :any,                 sonoma:        "db5a3659d9b8e2b00290f461e699c0d163ac6de59b350cc3d7c4cbe455baf681"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "72426b255ef36abd495cb353fb6697c2c0b91a09cc09808965dea6db8bae021d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4494590a88498f5bd9f1a8364946e733da2bbacaa8c01d0ba590b77396a838c5"
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