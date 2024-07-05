class LlamaCpp < Formula
  desc "LLM inference in CC++"
  homepage "https:github.comggerganovllama.cpp"
  # CMake uses Git to generate version information.
  url "https:github.comggerganovllama.cpp.git",
      tag:      "b3291",
      revision: "f619024764e72261f14d7c31d892b8fb976603b4"
  license "MIT"
  head "https:github.comggerganovllama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?b(\d+(?:\.\d+)*)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "c0f8b32921394a44d7d13b17ed66493edc67d041cedb6040fe2e8c87f78700c9"
    sha256 cellar: :any,                 arm64_ventura:  "09e2fd1a56c43eb8e7078d75c704e5a1d55246dadc8ce87b073abae2c881e3cc"
    sha256 cellar: :any,                 arm64_monterey: "c78ece108575dfb54967bff2f2fa174f3e70c679a30d3048947af8871c4f8883"
    sha256 cellar: :any,                 sonoma:         "85e31a79ef0fd52e0881069fc2dba028b5a6e61a8b32437fc0e8dc0dc114d356"
    sha256 cellar: :any,                 ventura:        "aea2ecf5e0e1dbdb7b48e382535d2410e648fa61f90290a9b8098e7f51a914ad"
    sha256 cellar: :any,                 monterey:       "9acf398bcde5db9d31a6083e59ec843e6b3509318a459783351c5d02c0cc09ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ca34c445682ca71244e6b62bfd891e0f8799d30eb193788ced178e44816b4e10"
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
    system bin"llama-cli", "--hf-repo", "ggml-orgtiny-llamas",
                            "-m", "stories260K.gguf",
                            "-n", "400", "-p", "I", "-ngl", "0"
  end
end