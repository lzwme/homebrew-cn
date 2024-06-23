class LlamaCpp < Formula
  desc "LLM inference in CC++"
  homepage "https:github.comggerganovllama.cpp"
  # CMake uses Git to generate version information.
  url "https:github.comggerganovllama.cpp.git",
      tag:      "b3202",
      revision: "3e58b0ee355f78be41cf5211b68426761339bc3c"
  license "MIT"
  head "https:github.comggerganovllama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?b(\d+(?:\.\d+)*)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "65eb7a20e4c3509ac8d729b654d46e3557187f36b7bda15bbf9a498c1c4b836c"
    sha256 cellar: :any,                 arm64_ventura:  "f7d1fda96a141897f79a7fa462e09814bd6a46dc3d053f650954cd904e29f4e9"
    sha256 cellar: :any,                 arm64_monterey: "25bd15da1627cbdd6b23c840182797beb53bac06568771985b96d913dafad319"
    sha256 cellar: :any,                 sonoma:         "9fd4aa1bf6b199fd7393e87f545e073cb507bb11286510bcfd8d63073d5441bf"
    sha256 cellar: :any,                 ventura:        "288d8fdbffc7ee64ee9130931326c04ba3c755e464fc58c2422bcbed0d3ecb8a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "407d94c06fd843e3a167b3d965053fdff59856207c7db0a28e3b09e520ce31c0"
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