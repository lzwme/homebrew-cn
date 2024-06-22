class LlamaCpp < Formula
  desc "LLM inference in CC++"
  homepage "https:github.comggerganovllama.cpp"
  # CMake uses Git to generate version information.
  url "https:github.comggerganovllama.cpp.git",
      tag:      "b3197",
      revision: "557b653dc9ed91e8c313e87500e0050c775f81b6"
  license "MIT"
  head "https:github.comggerganovllama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?b(\d+(?:\.\d+)*)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "a162e826341a1f0779b7156014a9621e1d5fb63c096ce5f6065af53f3f83b7da"
    sha256 cellar: :any,                 arm64_ventura:  "9a6cdb4a8bd9d5609723e62fb71324dbe0cb3842e9e263e75b5821681363b2a5"
    sha256 cellar: :any,                 arm64_monterey: "b2cb3110010ce943b7d5545e1946ff89d246036212cd2c13748ed298639db898"
    sha256 cellar: :any,                 sonoma:         "b6e5a1a23f5341818b4c78a7625b27b448b08cdf2f496d49c58b42f62ddb16e2"
    sha256 cellar: :any,                 ventura:        "e282920d14e78ff78e117cbd7731d1218abd98b5603866e55216bea722675ea9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "271b54f2895c33bd9103609175a9ab4b2e7cfdeba9ab51f8157b4ff727c1d741"
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