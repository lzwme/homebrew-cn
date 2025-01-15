class LlamaCpp < Formula
  desc "LLM inference in CC++"
  homepage "https:github.comggerganovllama.cpp"
  # CMake uses Git to generate version information.
  url "https:github.comggerganovllama.cpp.git",
      tag:      "b4481",
      revision: "091592d758cb55af7bfadd6c397f61db387aa8f3"
  license "MIT"
  head "https:github.comggerganovllama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?b(\d+(?:\.\d+)*)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "7fd6475eb27d79eaaae7130620ef0db9756f5e29012a94d38753616be28b2bee"
    sha256 cellar: :any,                 arm64_sonoma:  "a01e09e194562acffec4315e4916664ec3a0a755ebe884bfbd4f1fffaebf326a"
    sha256 cellar: :any,                 arm64_ventura: "3b151bd74621372743d14e369c8ebafffe93c1866ec620dc12cc4244195f2092"
    sha256 cellar: :any,                 sonoma:        "d4fd7a5529039a930445eb96b260d74e1115cb2956d114aa564664b0e96a8fc5"
    sha256 cellar: :any,                 ventura:       "68162970a73d0ea0d7c6fdb0159a4bde52d703a51c6cd1c8870923ed8b4f0f65"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6b5be41179ff65fead27017cd46915277def6d76cadfeea7fadef9650d0381d7"
  end

  depends_on "cmake" => :build
  uses_from_macos "curl"

  on_linux do
    depends_on "pkgconf" => :build
    depends_on "openblas"
  end

  def install
    args = %W[
      -DBUILD_SHARED_LIBS=ON
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DGGML_ACCELLERATE=#{OS.mac? ? "ON" : "OFF"}
      -DGGML_ALL_WARNINGS=OFF
      -DGGML_BLAS=ON
      -DGGML_BLAS_VENDOR=#{OS.mac? ? "Apple" : "OpenBLAS"}
      -DGGML_CCACHE=OFF
      -DGGML_LTO=ON
      -DGGML_METAL=#{(OS.mac? && !Hardware::CPU.intel?) ? "ON" : "OFF"}
      -DGGML_METAL_EMBED_LIBRARY=#{OS.mac? ? "ON" : "OFF"}
      -DGGML_NATIVE=#{build.bottle? ? "OFF" : "ON"}
      -DLLAMA_ALL_WARNINGS=OFF
      -DLLAMA_CURL=ON
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
    system libexec"test-sampling"
    # The test below is flaky on slower hardware.
    return if OS.mac? && Hardware::CPU.intel? && MacOS.version <= :monterey

    system bin"llama-cli", "--hf-repo", "ggml-orgtiny-llamas",
                            "-m", "stories260K.gguf",
                            "-n", "400", "-p", "I", "-ngl", "0"
  end
end