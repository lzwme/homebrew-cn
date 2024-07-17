class LlamaCpp < Formula
  desc "LLM inference in CC++"
  homepage "https:github.comggerganovllama.cpp"
  # CMake uses Git to generate version information.
  url "https:github.comggerganovllama.cpp.git",
      tag:      "b3403",
      revision: "37b12f92ab696d70f9a65d7447ce721b094fb32e"
  license "MIT"
  head "https:github.comggerganovllama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?b(\d+(?:\.\d+)*)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "c2e9d808b2d7b9b0cf070377318ff1cd90205ff3de456185e3641833196f35d6"
    sha256 cellar: :any,                 arm64_ventura:  "3634cbefe1fc87af73f184e92258041b57344c1e0810f2c1b614be61cfb24675"
    sha256 cellar: :any,                 arm64_monterey: "2c98ed1be2d962f5c45a617c67e87690a9e2efcc4f1cc898c33d96e2ae827f47"
    sha256 cellar: :any,                 sonoma:         "fd75827d17a6a9361d244109385eb42f9d99bcc949be07ce169c79199f4501d5"
    sha256 cellar: :any,                 ventura:        "3fa75e59786aae8b637085208b555d06add9e9bda9f5186a55246d6d3cd81050"
    sha256 cellar: :any,                 monterey:       "a8d9fff33479a17d25dd3f641b4cc26dd084e617f94781582d4e2979bef5557d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "63ce3153362b0dd28a7a34b866c31f8dd1567a66bc0c1340e03ced61a13ccb33"
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