class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://github.com/ggml-org/llama.cpp"
  # CMake uses Git to generate version information.
  url "https://github.com/ggml-org/llama.cpp.git",
      tag:      "b9080",
      revision: "9f5f0e689c9e977e5f23a27e344aa36082f44738"
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
    sha256 cellar: :any,                 arm64_tahoe:   "ed4ef1b6d8fcb248571c34f9f6515ca1372b9cb764d4f028ac4ad5f634a9a69e"
    sha256 cellar: :any,                 arm64_sequoia: "a8c4f273c3821a66c86cddb81cab9abde35f4bffb9f0ac3f2643a569475bfa5d"
    sha256 cellar: :any,                 arm64_sonoma:  "e79f8351683df1be6347cc5ae1919042708ed992ef9482bef211bfd8b9b86081"
    sha256 cellar: :any,                 sonoma:        "e14e8374ef6e286aff9375536a7e91096047db4ee3742b17709196263cf99fea"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "484d468ddc596ae42deaf5da362f70b2bc5ca34194530ded8601d4c63a1e965e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "35e991a985db2829ad57ec649f31158b4a991257e22a807812d1b0176826d511"
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