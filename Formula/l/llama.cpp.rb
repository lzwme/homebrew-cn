class LlamaCpp < Formula
  desc "LLM inference in CC++"
  homepage "https:github.comggerganovllama.cpp"
  # CMake uses Git to generate version information.
  url "https:github.comggerganovllama.cpp.git",
      tag:      "b3651",
      revision: "8f1d81a0b6f50b9bad72db0b6fcd299ad9ecd48c"
  license "MIT"
  head "https:github.comggerganovllama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?b(\d+(?:\.\d+)*)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "3f880eb1d3c4be89e01d2b06a38aab509a4884730980df919476feaefdb0b66e"
    sha256 cellar: :any,                 arm64_ventura:  "197bd57d9159a2f16353141812fa415d18c39a08488720b0f75b2e87c353c4df"
    sha256 cellar: :any,                 arm64_monterey: "5996cf6e7550c06c00ece92531526d0eb23fc2905941c1c876bc603b1bf4cdae"
    sha256 cellar: :any,                 sonoma:         "d35aa95466155ae731612e441033e3ea77f62992c2bdf062f1870f55d452687b"
    sha256 cellar: :any,                 ventura:        "68166db20f8e93c6a9071f15b1fe7e8dfcfac293b40400e55e658e5394edaf7b"
    sha256 cellar: :any,                 monterey:       "7943f4b6c47ef1df1a42be8df1b3f96a9bd415365ad42b2644985310fc35cbbf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "23ac0ae47278eac9a33a3bb7e66a609af127e86bed77e0639a69a0aff4edcfb9"
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