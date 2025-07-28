class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://github.com/ggml-org/llama.cpp"
  # CMake uses Git to generate version information.
  url "https://github.com/ggml-org/llama.cpp.git",
      tag:      "b6000",
      revision: "4762ad7316dcdec20016ab5985fb46a27902204d"
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
    sha256 cellar: :any,                 arm64_sequoia: "30eeef20f2da02a5a403ba3747c88847bfdfc230ac61ee62fb43ec71161b002c"
    sha256 cellar: :any,                 arm64_sonoma:  "5b625fecdb6d023cd39788c9b724a4071c97983905bb606ef1cd38a7bab1b042"
    sha256 cellar: :any,                 arm64_ventura: "5b841f67bfc2c3490d6cefc26c29650bd12df04dfb4e7f9eb4ea8aed2d56f0b4"
    sha256 cellar: :any,                 sonoma:        "59550d35440b398f99efd1526b5aaf4923ac3e766ce04fb8fc7a2a534dcdec2e"
    sha256 cellar: :any,                 ventura:       "42507e1c1367a4c210cff89c0945cb615d187cdc3ba4e4e3a1575223d1d68385"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "200bb7c80d3a2f5a40e84de81983bc72cca42c8269b7d53ce194d1746fc48ae8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e58ebb1f54116eb2e0d39c35c46478e740bbd65ee1be8a8b932fc59ffea6806f"
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