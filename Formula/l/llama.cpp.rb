class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://github.com/ggml-org/llama.cpp"
  # CMake uses Git to generate version information.
  url "https://github.com/ggml-org/llama.cpp.git",
      tag:      "b6290",
      revision: "a6a58d64785cb458ed9de52f391aa38142d38d64"
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
    sha256 cellar: :any,                 arm64_sequoia: "4db96639cad39049e91dde6c276021b8bf367ba93e70f51b7e14befa822ab4db"
    sha256 cellar: :any,                 arm64_sonoma:  "0673acb2cda4adf889ad7a7a3c326e794c08b3e189612c7abc00310ddd323e6e"
    sha256 cellar: :any,                 arm64_ventura: "bcf5c0388c12e1042bff9aaa438b847cdcc2b057063ab9e99c29d9f982c8bed0"
    sha256 cellar: :any,                 sonoma:        "ab4f515ac61975104c9445c39f7c53d9d3d4ed7cb27e0065f409ca5bfcbddc2a"
    sha256 cellar: :any,                 ventura:       "010dc2b894fce5b2fe32b1d617f642ab8b67f26f533f1228a0bde7eaf288fb29"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c46dcecdbe55b954171745fd41f061da394116db0dbcee0d275ccfd56a9c0690"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cc428323dd22f130f5abc058deffcd3e7c65b8865b9658c830cb2e9d644364e5"
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