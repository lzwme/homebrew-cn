class LlamaCpp < Formula
  desc "LLM inference in CC++"
  homepage "https:github.comggerganovllama.cpp"
  # CMake uses Git to generate version information.
  url "https:github.comggerganovllama.cpp.git",
      tag:      "b3643",
      revision: "9f7d4bcf5c27d37b0c7da82eeaf9c1499510554b"
  license "MIT"
  head "https:github.comggerganovllama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?b(\d+(?:\.\d+)*)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "0d2839851475b374929f127dde2f114bf2cc36b8afa5484c06c9020c8a0212b7"
    sha256 cellar: :any,                 arm64_ventura:  "eece1a9264fad9cf25ee1e31cb51ac8eddf51ca200cda1d4d197e68c14900bd5"
    sha256 cellar: :any,                 arm64_monterey: "bd3acc90e14d6e25e83092713a8d8879c865903885f34a44b82080b93e39b58e"
    sha256 cellar: :any,                 sonoma:         "d35e716c9a0ef4bb43cc93fe239651d794ab5292fbf48a9b5934a2fbe28189e5"
    sha256 cellar: :any,                 ventura:        "bdd35fcadee3da8852cea06cb89c4cf8428dd6c1432000b215ce572fb9d10f96"
    sha256 cellar: :any,                 monterey:       "1da700d950ba2b2628c9586b3aa447b78839cb2c7cfd9b99c3f554ef2972d57f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3dec72060fb0689bc2c0adb5a81631fe1687e3805cf4a71de69af24334e8d487"
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