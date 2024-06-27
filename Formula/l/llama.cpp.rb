class LlamaCpp < Formula
  desc "LLM inference in CC++"
  homepage "https:github.comggerganovllama.cpp"
  # CMake uses Git to generate version information.
  url "https:github.comggerganovllama.cpp.git",
      tag:      "b3233",
      revision: "494165f3b6c4cbcd793123cb57fb3e1f5477f1db"
  license "MIT"
  head "https:github.comggerganovllama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?b(\d+(?:\.\d+)*)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "199221cec4fc4df439c15ebf379007097cbf939f36cb554bdea2e903d72df5dc"
    sha256 cellar: :any,                 arm64_ventura:  "997a699e679585e7cebeb7446bc5014c3846b857af34662698cdb8b64828d5f4"
    sha256 cellar: :any,                 arm64_monterey: "0ee45c72f321bdb3ce5891ada1dee24b958ec1c56dac7a114e74cdaa39fec1e9"
    sha256 cellar: :any,                 sonoma:         "f68a6f20183e4f853a827ab585dd09cad65c5dec3e2521d0f4ba0e062e7d8a8f"
    sha256 cellar: :any,                 ventura:        "9afcb0d7d16d9f9861802665bd7e3aa212f57f02ecdb3b483096ae7ae70adda1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ceb397992a4543ee3bd7546f59fc0bf4a17cc58cc0f3040d4be2e7bf65226661"
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