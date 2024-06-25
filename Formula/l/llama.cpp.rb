class LlamaCpp < Formula
  desc "LLM inference in CC++"
  homepage "https:github.comggerganovllama.cpp"
  # CMake uses Git to generate version information.
  url "https:github.comggerganovllama.cpp.git",
      tag:      "b3216",
      revision: "a818f3028d1497a51cb2b8eb7d993ad58784940e"
  license "MIT"
  head "https:github.comggerganovllama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?b(\d+(?:\.\d+)*)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "727b4b5ff0902238f5d81f2a4ac6ca3eebe63b78f314d242029f61f7fc1451ed"
    sha256 cellar: :any,                 arm64_ventura:  "29d99bf66ff446080ca35988256fc1b2fd574fb30ff42b10a11afe9116eda673"
    sha256 cellar: :any,                 arm64_monterey: "f9b3eb09fa9b19a8fbf0ca6740973b6476814f9e149c5dcf1c9e5cc660e65fd0"
    sha256 cellar: :any,                 sonoma:         "8b699fe707fd4a60f3ad3469587a641f2cbcdc1645613d8b56e31956b6b17b17"
    sha256 cellar: :any,                 ventura:        "203d3fb23f0e4001739216897c74ce1ffbc85c60500905794d0120b1c36a6875"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d73219893f8e672d94670f34214233433fea02f1e927267526999f00c46a18fd"
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