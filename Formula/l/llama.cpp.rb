class LlamaCpp < Formula
  desc "LLM inference in CC++"
  homepage "https:github.comggerganovllama.cpp"
  # CMake uses Git to generate version information.
  url "https:github.comggerganovllama.cpp.git",
      tag:      "b3262",
      revision: "38373cfbab5397cc2ab5c3694a3dee12a9e58f45"
  license "MIT"
  head "https:github.comggerganovllama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?b(\d+(?:\.\d+)*)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "098c1d004395c81a252f8b4fd4651bb000a9bcedf2e01a8287584247834447c6"
    sha256 cellar: :any,                 arm64_ventura:  "3cb6186b0650aed9e59ac1d1a03fed153b9ffaec6dd99ddeb1e0133b471d8deb"
    sha256 cellar: :any,                 arm64_monterey: "2c20a4a602556c11d7c5240d14749dc8eb46ab269e290a2ae3002d80d3166723"
    sha256 cellar: :any,                 sonoma:         "8fcf6369c795fadfffc4922b44cad56ebed7b769d6bcea5b05ff4589dbddd9fa"
    sha256 cellar: :any,                 ventura:        "8b3bb3c006ba6573b895b0fa4d5f7a25760f0038ca338e36f934617896d74c4f"
    sha256 cellar: :any,                 monterey:       "736ec870a47b77a2aa6df741e443da3fdaf2895b943c0b612041b77219d489e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8eb83cc423152f7d5d91869bcc33fa4b1eff4fec29bea1829b26192195b6a81b"
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