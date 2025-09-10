class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://github.com/ggml-org/llama.cpp"
  # CMake uses Git to generate version information.
  url "https://github.com/ggml-org/llama.cpp.git",
      tag:      "b6430",
      revision: "17bc5a815f0bebc1844c99796760cd7df5e9b8d9"
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
    sha256 cellar: :any,                 arm64_sequoia: "8c0196f85aa04c1b9da781309d5669b006f809bdd797e0af379531f9b8e902bf"
    sha256 cellar: :any,                 arm64_sonoma:  "fc964cd194155e4d23dbb2ded3c6c1a7278e09b4feb36a1dc1ded0a920780878"
    sha256 cellar: :any,                 arm64_ventura: "237d7c30b1910d04f600b0a46d877f348c7cf50dbdbe98f49eea0ed40f32526f"
    sha256 cellar: :any,                 sonoma:        "b0cc3051a4e6009894bcc089d74c1704beef9ae20bbe77e808e91766b4d4106e"
    sha256 cellar: :any,                 ventura:       "4cfd9eeb538e3c1e44663b390736e6d68aa1e540b8c42ad62926dbb9a6dd7938"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "89e7aecb08ae515f862c7c7a370e91372fc39a898c60a92afeb16af46532eed8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bf63c29dc4af1206836eca3336a40236bec90ccbd4ed1890fef64eef949a0a3a"
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