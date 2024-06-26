class LlamaCpp < Formula
  desc "LLM inference in CC++"
  homepage "https:github.comggerganovllama.cpp"
  # CMake uses Git to generate version information.
  url "https:github.comggerganovllama.cpp.git",
      tag:      "b3228",
      revision: "e6bf007744eb06336a231ef39cf08146dd16d2ce"
  license "MIT"
  head "https:github.comggerganovllama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?b(\d+(?:\.\d+)*)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "1a694852c8dfb2ba9a89babf1b3fb22bc24cbe026ba314bd0ab50712946339c5"
    sha256 cellar: :any,                 arm64_ventura:  "68e63920d63eef256df165395a6f80cc60ae2d8a0f8503478efd3574449604dd"
    sha256 cellar: :any,                 arm64_monterey: "9dce94d07b4ce01d7b2696ecefb1d5626ac24c6bb3500e5cb9fa41b8bf44e3f5"
    sha256 cellar: :any,                 sonoma:         "4c15dde38a9f5dde4aa44aee11c6fe99df27cf3342747c1e0b704511d29963d1"
    sha256 cellar: :any,                 ventura:        "6d2020fe89c767a869fb067493bdacde6b69bc9a9231babde0e3c618531fec2d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0edadeacad16e6b629e731dc822012b122a7049e320cfebf3832370c6a3c2677"
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