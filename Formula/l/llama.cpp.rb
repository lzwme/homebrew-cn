class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://github.com/ggml-org/llama.cpp"
  # CMake uses Git to generate version information.
  url "https://github.com/ggml-org/llama.cpp.git",
      tag:      "b5980",
      revision: "820de57d4faa427a3d0bfb14e48057247fae036e"
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
    sha256 cellar: :any,                 arm64_sequoia: "6baf9ca42ca9297506cb2f27f025101fcb652e1f4072c5954997219764e27382"
    sha256 cellar: :any,                 arm64_sonoma:  "5221b6a6f70c7f18234243aba2857b88640bc71c002dd10f99948c18f29256e8"
    sha256 cellar: :any,                 arm64_ventura: "d7116f3e911cf6f9b23229503d499e63f5cc9997a56f7c1e08b03cd45ba2f514"
    sha256 cellar: :any,                 sonoma:        "2243e00601d03b0850c6cabeabc602763bee381e6478ec658141092c4db60799"
    sha256 cellar: :any,                 ventura:       "f63dc74e1005c8746a6e4baf6be98ff2f2ab8d1453994148a97627836eb13429"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "110374c9280cc1f3d106926e92ea7fbc2d62acc79a0493be6f3c6372eb803009"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7bbb0dab7754abdc2954ed9a13eabce6a56db6aa2ce1c6291045eba2f631430e"
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