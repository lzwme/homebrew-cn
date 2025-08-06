class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://github.com/ggml-org/llama.cpp"
  # CMake uses Git to generate version information.
  url "https://github.com/ggml-org/llama.cpp.git",
      tag:      "b6090",
      revision: "ee3a9fcf88fe5b5e1213711e05861b83cd4fdfe6"
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
    sha256 cellar: :any,                 arm64_sequoia: "257ff485fd5b3157dcd6b3dcca8d257145dc7784266fc0122e742ae70ca6aac8"
    sha256 cellar: :any,                 arm64_sonoma:  "b3575eee10ba776ea9bc66e7f399f9a11f53796907a5ef2e087e1b6f9943836d"
    sha256 cellar: :any,                 arm64_ventura: "5ee8af934eed7ab289ae80e5bff537f72b6c1ba74d98e085a94d6fc5c7836864"
    sha256 cellar: :any,                 sonoma:        "e74c728901577bbb5e5746064c70c124482c18da0662f296cc5fce6333cba89d"
    sha256 cellar: :any,                 ventura:       "72019e1231357c31c907b517803c6a1bf459ed80e7c4de1e354d6283fe6fb1f8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a1566218b12ca82183396c78a56c7012fbce5336499795c676f1d93ed8a6bc05"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ebce54815682f1eebb9b8efb6f708cdffd428ae91a8c70cf5884990b62251fb6"
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