class LlamaCpp < Formula
  desc "LLM inference in CC++"
  homepage "https:github.comggerganovllama.cpp"
  # CMake uses Git to generate version information.
  url "https:github.comggerganovllama.cpp.git",
      tag:      "b3658",
      revision: "f1485161e58d562099dd050f8ac3a9ea9f4cd765"
  license "MIT"
  head "https:github.comggerganovllama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?b(\d+(?:\.\d+)*)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "d14df94b94098bb25136f59b96c00c2c7c6c599613b7fb8aa99266dbfd583cdd"
    sha256 cellar: :any,                 arm64_ventura:  "8a647befdae6a6ad36dc51ec658b5b13507b6fbf2b205afec3a7a1d136c1572e"
    sha256 cellar: :any,                 arm64_monterey: "561b5e955bc6dac7242e7c750b09f2d451209a8a6efc68b78ec5094066fd82ae"
    sha256 cellar: :any,                 sonoma:         "cd93ba6eec2c78bb443d1f02c061f62d7e9bfe882325b884dd0f542ff869d8ea"
    sha256 cellar: :any,                 ventura:        "3cbff27eb26ed2d8db7957ca085cb16ecfe3ab61b10f965cbe308a39d9fe4021"
    sha256 cellar: :any,                 monterey:       "fa34126c69fce4f1252f5b01049224e5ac3ed1e6e323dc604d3b4179b0c27fa9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d884e96e97e0a31a66f0cc8813407fbc7411ba6ef8c11c45605e48f57172af02"
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