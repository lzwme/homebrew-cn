class LlamaCpp < Formula
  desc "LLM inference in CC++"
  homepage "https:github.comggerganovllama.cpp"
  # CMake uses Git to generate version information.
  url "https:github.comggerganovllama.cpp.git",
      tag:      "b3755",
      revision: "822b6322dea704110797a5671fc80ae39ee6ac97"
  license "MIT"
  head "https:github.comggerganovllama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?b(\d+(?:\.\d+)*)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "8b4266fa3d42e9ffe2b11e7c9ab5d27551a1bcc58bfa7038cfa84db1f6f4fb64"
    sha256 cellar: :any,                 arm64_sonoma:  "e31eb0d8b65c6ca088d66973fdcb2c15820093afb975bee92fde5b16d9b01366"
    sha256 cellar: :any,                 arm64_ventura: "2ebd7c46df473c653232fbcc927b7b2415f302a00c23dcc8c03b9154f51502c3"
    sha256 cellar: :any,                 sonoma:        "eace0125b4583f28870afe35048a083faac5b5b3ce259122cfec2426369e0a60"
    sha256 cellar: :any,                 ventura:       "edca9261dd588d68d242df395cf2eb20a94095523461788adf2dbc4459c2c2c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "139aea6d2ab056614617b3b7eb01b4000365e85b33f928e57f049d28363a8f25"
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
    system libexec"test-sampling"
    # The test below is flaky on slower hardware.
    return if OS.mac? && Hardware::CPU.intel? && MacOS.version <= :monterey

    system bin"llama-cli", "--hf-repo", "ggml-orgtiny-llamas",
                            "-m", "stories260K.gguf",
                            "-n", "400", "-p", "I", "-ngl", "0"
  end
end