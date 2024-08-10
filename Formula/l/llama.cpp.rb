class LlamaCpp < Formula
  desc "LLM inference in CC++"
  homepage "https:github.comggerganovllama.cpp"
  # CMake uses Git to generate version information.
  url "https:github.comggerganovllama.cpp.git",
      tag:      "b3560",
      revision: "6afd1a99dc9792096d4567ab9fa1ad530c81c6cd"
  license "MIT"
  head "https:github.comggerganovllama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?b(\d+(?:\.\d+)*)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "3a86ded5b5e40cf86e9b4df34ed51b97ca8ff2f0f82bba844112d6d766859b5c"
    sha256 cellar: :any,                 arm64_ventura:  "7dd13a02c4827dd6b34f551baee99d75a0c103ee25d8f3d4bc72fc5bccfa9ba6"
    sha256 cellar: :any,                 arm64_monterey: "d825ed9a64a1116d962f956284f431b637d58e57d7aca574e8caf749e706d657"
    sha256 cellar: :any,                 sonoma:         "a806be20e7077d61b26b3cb70bf72ce4841ec7f776ff36f629ce60b6363fa5fc"
    sha256 cellar: :any,                 ventura:        "1054b96c030b28c24daf761a6aaf3e6e7d12695d9a4440e32c7116bcff0b3809"
    sha256 cellar: :any,                 monterey:       "aaf7ebceebc8bfb339c1a22ee13dc62af96d9ccae96d9561fc5e687d766cbbda"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "23255d27c5201f4d9bedd19309b1bada6f683692b0d36de2663bf0b1b5e663f7"
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