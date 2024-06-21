class LlamaCpp < Formula
  desc "LLM inference in CC++"
  homepage "https:github.comggerganovllama.cpp"
  # CMake uses Git to generate version information.
  url "https:github.comggerganovllama.cpp.git",
      tag:      "b3190",
      revision: "abd894ad96a242043b8e197ec130d8649eead22e"
  license "MIT"
  head "https:github.comggerganovllama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?b(\d+(?:\.\d+)*)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "d03f39a2bdb36a0a15ff8562aba8ed8a7f5bbc9f654d3e0ad10bca3744c585aa"
    sha256 cellar: :any,                 arm64_ventura:  "5420438bf9d42a42f4df9444ef7e12b7640e1e9f56f74fdaf8ff1187d1a58c1d"
    sha256 cellar: :any,                 arm64_monterey: "0657538d4dc0d6f716ad22124d33cf00e771f824f60f7833ab4d8ab28e602ec5"
    sha256 cellar: :any,                 sonoma:         "9ce5e3f13c68d6559b0080791e04560b16fdf6c2dc6138eb33482c2275c2d70d"
    sha256 cellar: :any,                 ventura:        "44a39a257ca3fcaff63b6184d7cadd24ddc226332224266f07dff9962e7c5bb1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ab7a0ccdd88fe737edd6b0baf534034219e8d0d68cbe9d92c64ae4f7feda8df9"
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