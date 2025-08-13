class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://github.com/ggml-org/llama.cpp"
  # CMake uses Git to generate version information.
  url "https://github.com/ggml-org/llama.cpp.git",
      tag:      "b6140",
      revision: "b0493156fa8622694f21f42460a84da3eded0bc0"
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
    sha256 cellar: :any,                 arm64_sequoia: "df5d35bb4ad55333eb533d83e168eeb88761638f8ccc71ebf9fd49adc4db68b5"
    sha256 cellar: :any,                 arm64_sonoma:  "2dcc27d14966d411d39c8d4d04a2fc30dce998c294d1fa9b66ae631f541358c1"
    sha256 cellar: :any,                 arm64_ventura: "41eae031fd8a0a6eaad72d29ae33e9e40e13966ab1502de636a6b20d8f028267"
    sha256 cellar: :any,                 sonoma:        "d81f448ce85ca486cb5b9eefa07da54384b39de7faa299498cf53714ba445a3b"
    sha256 cellar: :any,                 ventura:       "5932cd4471db662aa978d23a658c095c0c88cfb11cb47fae6146187a98a321b0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "305400c4ec1a484d560caab0812cbbc2d274e3cbb567df4789e1831f2c5c5298"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bb423dee5528bed56eaa5c97e290bb8dbdd805aedb2b9d6761d159f4457a48b8"
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