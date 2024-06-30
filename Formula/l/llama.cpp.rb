class LlamaCpp < Formula
  desc "LLM inference in CC++"
  homepage "https:github.comggerganovllama.cpp"
  # CMake uses Git to generate version information.
  url "https:github.comggerganovllama.cpp.git",
      tag:      "b3265",
      revision: "72272b83a3878e91251218c981b4c6ec16c33912"
  license "MIT"
  head "https:github.comggerganovllama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?b(\d+(?:\.\d+)*)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "9ebc8475333f77bd4a0ab128a3d8f55a39a954e9eb167224aeac0f90cadb10f7"
    sha256 cellar: :any,                 arm64_ventura:  "1b1c215dfc72442b85f643be903775ab84301c4686219abd91bc665523520315"
    sha256 cellar: :any,                 arm64_monterey: "9d697e7a3bbfab718308fc8e49dc8b30fc39f4e4f4d6ba4c401842a186893f13"
    sha256 cellar: :any,                 sonoma:         "a0b98b3685dd7cd6c83d1b933a82bb437a11a933303daa5bd17736840b36bf6a"
    sha256 cellar: :any,                 ventura:        "5fdeead77d9e97e37cfa7b9330fb6b5f2f9b692384eeb3f2839a4ed71532b955"
    sha256 cellar: :any,                 monterey:       "ae0d5d4918f4f540a99a9a3c3a6d8e920665320200793c7a8140d95d113487f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d47de9670f53bc5bb91ecbaa826d5b3b76ffe3cafd79035dfdcb70ca62de16a7"
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