class LlamaCpp < Formula
  desc "LLM inference in CC++"
  homepage "https:github.comggerganovllama.cpp"
  # CMake uses Git to generate version information.
  url "https:github.comggerganovllama.cpp.git",
      tag:      "b3795",
      revision: "d13edb17ed1ce3b961016cbdb616b1c8d161c026"
  license "MIT"
  head "https:github.comggerganovllama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?b(\d+(?:\.\d+)*)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "6e3e952e5ef458dc712f809029f606fec5e6276b5ef431591dccfff4769b5dbf"
    sha256 cellar: :any,                 arm64_sonoma:  "d0c11966291ddb5f170c0342021c595219b21507d9c6dd07b4501cb3e4e2b912"
    sha256 cellar: :any,                 arm64_ventura: "6a11edb26d0984f2e2cd1c56213d7b5c9a0c6eba7c16f0699504659896123b53"
    sha256 cellar: :any,                 sonoma:        "2e302023b34791fc27daa3c6ad1eea93c51fb857468170cfe22377a1539dad7a"
    sha256 cellar: :any,                 ventura:       "d9a6fc044cbaec634a27a36b5689b6fa1f444eff8471dc091e864d2cf767fdba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "00c64fd5831ec7ef652905cfeab910638ddb084b24ebd0e10a7d92c68b47c927"
  end

  depends_on "cmake" => :build
  uses_from_macos "curl"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openblas"
  end

  def install
    args = %W[
      -DBUILD_SHARED_LIBS=ON
      -DLLAMA_LTO=ON
      -DLLAMA_CCACHE=OFF
      -DLLAMA_ALL_WARNINGS=OFF
      -DLLAMA_NATIVE=#{build.bottle? ? "OFF" : "ON"}
      -DLLAMA_ACCELLERATE=#{OS.mac? ? "ON" : "OFF"}
      -DLLAMA_BLAS=#{OS.linux? ? "ON" : "OFF"}
      -DLLAMA_BLAS_VENDOR=OpenBLAS
      -DLLAMA_METAL=#{OS.mac? ? "ON" : "OFF"}
      -DLLAMA_METAL_EMBED_LIBRARY=ON
      -DLLAMA_CURL=ON
      -DCMAKE_INSTALL_RPATH=#{rpath}
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