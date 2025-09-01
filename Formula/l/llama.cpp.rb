class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://github.com/ggml-org/llama.cpp"
  # CMake uses Git to generate version information.
  url "https://github.com/ggml-org/llama.cpp.git",
      tag:      "b6330",
      revision: "5c16b9c87d840e4d5d55fa83c732c6b693346f40"
  license "MIT"
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
    sha256 cellar: :any,                 arm64_sequoia: "ab2d530f543e77d5bef1e93fa7002a33ef6031843b90e72b70789c6ac1df7537"
    sha256 cellar: :any,                 arm64_sonoma:  "45f426369043ad2a891f50e3c958c3298f22348e091ff49f7c520e84c76af9f4"
    sha256 cellar: :any,                 arm64_ventura: "71c3ba590988f5f61b715c81543410e5d569fcf29650a2710f0e17e204857066"
    sha256 cellar: :any,                 sonoma:        "64eef9ebc7dbfdbb87767224cefc4bd12a0dce669e13b20366974dbd27259eb4"
    sha256 cellar: :any,                 ventura:       "fff63494b086c3d47e7833156f6a2a1023d8454538da3ec513b0577fb89147da"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7d469f067e4a71eb54b77cfc62746bfa2955cba7e08d2797b5db184b8f2a7931"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ef5dfe3db9d2b1a4688d09c2176707f1bb35b3741378c768427bb567e2fcebd8"
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