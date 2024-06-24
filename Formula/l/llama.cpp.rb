class LlamaCpp < Formula
  desc "LLM inference in CC++"
  homepage "https:github.comggerganovllama.cpp"
  # CMake uses Git to generate version information.
  url "https:github.comggerganovllama.cpp.git",
      tag:      "b3208",
      revision: "e112b610a1a75cb7fa8351e1a933e2e7a755a5ce"
  license "MIT"
  head "https:github.comggerganovllama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?b(\d+(?:\.\d+)*)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "1e26d9ad90074b7c05110274db02b0e7061ce7d7b0c623d7d9561995d3490b2b"
    sha256 cellar: :any,                 arm64_ventura:  "92b5ced7a6735ef296b4160280a3a89e68d23670507f25f279e1e4f1bad2a351"
    sha256 cellar: :any,                 arm64_monterey: "d7ded45a4b70f8fe55e59df3f1d4a993e5dc4685dd8a57ce051194ba2791ab6f"
    sha256 cellar: :any,                 sonoma:         "6fbc25cfda38765f88b57a1aef1647c9e5eb6844986dc431f14c4cc264aced97"
    sha256 cellar: :any,                 ventura:        "dd477be10d08e482b0b28b6a192056376df78c4b12179f9b3e8b0d98727a2da6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b4b51aec80d0f391620b52aaa77f5ffb6a14e37d7033b00e0110d6be05c10f8a"
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