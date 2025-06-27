class LlamaCpp < Formula
  desc "LLM inference in CC++"
  homepage "https:github.comggml-orgllama.cpp"
  # CMake uses Git to generate version information.
  url "https:github.comggml-orgllama.cpp.git",
      tag:      "b5760",
      revision: "e8215dbb96b8fb94a24c29cdd228166fb972dbfc"
  license "MIT"
  head "https:github.comggml-orgllama.cpp.git", branch: "master"

  # llama.cpp publishes new tags too often
  # Having multiple updates in one day is not very convenient
  # Update formula only after 10 new tags (1 update per ≈2 days)
  #
  # `trottle 10` doesn't work
  livecheck do
    url :stable
    regex(^v?b(\d+(?:\.\d+)*0)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "171dd1e37f8481a7564a79ec872e049a881e7d503beb1b87b70caa209ad0669d"
    sha256 cellar: :any,                 arm64_sonoma:  "33200195c0b5c922509abc424e5a57595beb5eb8b34081f1306337faacbb21c8"
    sha256 cellar: :any,                 arm64_ventura: "675dbbbec417d229b747b6b86e9966d850cf4fc3e7e945ef1b0e3ebf1d95a463"
    sha256 cellar: :any,                 sonoma:        "e54a3a3b5b5b16f0f01f54f26f40b24865142e7e19c9277e24851b8cbeb2cbcb"
    sha256 cellar: :any,                 ventura:       "ba1292995cac82142852215c350b214ea4da3ec51a1f88bb69bab33dec458a88"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d81f04d48e7511866e7c117b38789b21abdfe8d85ba106759fc376448e59824d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "319e81e7332b659d7a15c5461de7cf32c4b2608d58e7699607d500b0e6539647"
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
    system libexec"test-sampling"
    # The test below is flaky on slower hardware.
    return if OS.mac? && Hardware::CPU.intel? && MacOS.version <= :monterey

    system bin"llama-cli", "--hf-repo", "ggml-orgtiny-llamas",
                            "-m", "stories260K.gguf",
                            "-n", "400", "-p", "I", "-ngl", "0"
  end
end