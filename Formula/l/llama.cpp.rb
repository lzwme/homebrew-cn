class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://github.com/ggml-org/llama.cpp"
  # CMake uses Git to generate version information.
  url "https://github.com/ggml-org/llama.cpp.git",
      tag:      "b6080",
      revision: "0a2f5496bef9e54e5f42d6c2c3ad9eb7b379aed0"
  license "MIT"
  head "https://github.com/ggml-org/llama.cpp.git", branch: "master"

  # llama.cpp publishes new tags too often
  # Having multiple updates in one day is not very convenient
  # Update formula only after 10 new tags (1 update per ≈2 days)
  #
  # `trottle 10` doesn't work
  livecheck do
    url :stable
    regex(/^v?b(\d+(?:\.\d+)*0)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "0d0362e6db04152b71eb9ce44694afc36efa78a0adf2117cc415c88080992371"
    sha256 cellar: :any,                 arm64_sonoma:  "c23a639559def238cb3b7010e1f2d23d8c275ad0f4a315c60e00526d7e5d8aac"
    sha256 cellar: :any,                 arm64_ventura: "872d6c93999f26cbe2e3f72407709a7c476663c620d1d94a718d398ae790b4b0"
    sha256 cellar: :any,                 sonoma:        "b9af7669fd90de29aeb51a758bef9e455ebc0d1a37ca386b108e639bf4a07a38"
    sha256 cellar: :any,                 ventura:       "30fa8524fdd24273c82d5b6cba71edb877c1898f5a858b4957476eaabb0de0ce"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a36a9b1eec0a20c288fed8bf58a2d9540661ecc69c209c44a8d6683dc3fbbe23"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "db72aa8eceec51bdba922a39aa432ffde238324b8c78d94813bd1821f222dbbf"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  uses_from_macos "curl"

  on_linux do
    depends_on "openblas"
  end

  def install
    args = %W[
      -DBUILD_SHARED_LIBS=ON
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DGGML_ACCELERATE=#{OS.mac? ? "ON" : "OFF"}
      -DGGML_ALL_WARNINGS=OFF
      -DGGML_BLAS=ON
      -DGGML_BLAS_VENDOR=#{OS.mac? ? "Apple" : "OpenBLAS"}
      -DGGML_CCACHE=OFF
      -DGGML_LTO=ON
      -DGGML_METAL=#{(OS.mac? && !Hardware::CPU.intel?) ? "ON" : "OFF"}
      -DGGML_METAL_EMBED_LIBRARY=#{OS.mac? ? "ON" : "OFF"}
      -DGGML_NATIVE=#{build.bottle? ? "OFF" : "ON"}
      -DLLAMA_ALL_WARNINGS=OFF
      -DLLAMA_CURL=ON
    ]
    args << "-DLLAMA_METAL_MACOSX_VERSION_MIN=#{MacOS.version}" if OS.mac?

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    libexec.install bin.children
    bin.install_symlink libexec.children.select { |file|
                          file.executable? && !file.basename.to_s.start_with?("test-")
                        }
  end

  test do
    system libexec/"test-sampling"
    # The test below is flaky on slower hardware.
    return if OS.mac? && Hardware::CPU.intel? && MacOS.version <= :monterey

    system bin/"llama-cli", "--hf-repo", "ggml-org/tiny-llamas",
                            "-m", "stories260K.gguf",
                            "-n", "400", "-p", "I", "-ngl", "0"
  end
end