class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://llama.app"
  # CMake uses Git to generate version information.
  url "https://github.com/ggml-org/llama.cpp.git",
      tag:      "b10210",
      revision: "000547513f1530346ecd163db8b3e13962949961"
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
    sha256 cellar: :any, arm64_tahoe:   "a8d7ca5a59a052f9774462c92bc52cd98e021cb5776abe3e78ae082fddb9de67"
    sha256 cellar: :any, arm64_sequoia: "1d8122b6f6a75e4a495d26be2eabe2d3053e03773c291c5b49482cdb5350f559"
    sha256 cellar: :any, arm64_sonoma:  "5ca421c8f4a4a6b377cc376109947eeff11fa15832019582563001fa39488280"
    sha256 cellar: :any, sonoma:        "365efdc01f56a54d463d70c41f4d8781f2c05a44b3184fe5b1f8d103042dffa4"
    sha256 cellar: :any, arm64_linux:   "8f47b63bb66b8db412f87b38d695d757d9539f31269c1349e977d8d007ce43af"
    sha256 cellar: :any, x86_64_linux:  "0d807802de2e78cf37e5029bc8c4624ceaf80b24485f09ae34c39fd88d960c85"
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