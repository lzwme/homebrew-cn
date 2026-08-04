class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://llama.app"
  # CMake uses Git to generate version information.
  url "https://github.com/ggml-org/llama.cpp.git",
      tag:      "b10240",
      revision: "0b14b87d7c20cb753b94b96854dd7b45306fc696"
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
    sha256 cellar: :any, arm64_tahoe:   "71668f508a9bd87bf6768f386f47885b2cfb89997318a2d8ab090b7b7d1c1237"
    sha256 cellar: :any, arm64_sequoia: "22b0926c3bf746819f7d300c736a9c1e34de9c1426dee47de0b6ca92a53ffea3"
    sha256 cellar: :any, arm64_sonoma:  "f48d30ffe6b829399cfa60977b2acaf34d7bc87b2d99e6db91839f9873dd5a25"
    sha256 cellar: :any, sonoma:        "51993f07796c34baa732604123ef6e5beaba8c30ba89778729316d9ddecdeab7"
    sha256 cellar: :any, arm64_linux:   "8a64124c024e4d3dd62292cba8672f4e990adc30cda8c82451a9dac627342679"
    sha256 cellar: :any, x86_64_linux:  "2877bc78bcb56c375c24a6cfca017b1140d1d17b09db5231311669161089e2e6"
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