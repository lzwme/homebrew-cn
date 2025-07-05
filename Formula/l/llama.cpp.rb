class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://github.com/ggml-org/llama.cpp"
  # CMake uses Git to generate version information.
  url "https://github.com/ggml-org/llama.cpp.git",
      tag:      "b5820",
      revision: "c8c4495b8d3a8799e2d46778f993965b0ac1ae43"
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
    sha256 cellar: :any,                 arm64_sequoia: "fde220e2dc018c81303f2ef97d7da20ff091131a4fecbb23c2a82a5fdc9f63fb"
    sha256 cellar: :any,                 arm64_sonoma:  "e6eec5c5d03b2b5a460325285cca11dfc538f1575835d2cdbf2f229e94cf4574"
    sha256 cellar: :any,                 arm64_ventura: "e1dabb1195aa913125875d657f118e33e9d4a68b2061cc73b9b247a1f96e1b65"
    sha256 cellar: :any,                 sonoma:        "327c5620ed38c0f1ae381c63492efc3be90a3617a3b0426dc7bea1cbffd8f732"
    sha256 cellar: :any,                 ventura:       "699933941bf6e8fe51c7ba19a0354bc04ef85b8d7719e415c81e72f85e3100db"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "840cfd3cc02e0b07c0e136373b1e45d4ff93402beec0fd4dd4a6924070e069cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0c4c3354d8040624aa978da3b12b6dbd8fa6120f3ae5624f75bfa91197326ec7"
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
      -DGGML_ACCELLERATE=#{OS.mac? ? "ON" : "OFF"}
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