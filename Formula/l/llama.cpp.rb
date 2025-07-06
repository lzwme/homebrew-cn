class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://github.com/ggml-org/llama.cpp"
  # CMake uses Git to generate version information.
  url "https://github.com/ggml-org/llama.cpp.git",
      tag:      "b5830",
      revision: "bac8bed248d15419137c5bc7f834582397baaebc"
  license "MIT"
  head "https://github.com/ggml-org/llama.cpp.git", branch: "master"

  # llama.cpp publishes new tags too often
  # Having multiple updates in one day is not very convenient
  # Update formula only after 10 new tags (1 update per ≈2 days)
  #
  # `trottle 10` doesn't work
  livecheck do
    url :stable
    regex(/^v?b(\d+(?:\.\d+)*0)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "be433cbbe1d4287d04979f48ce633c5ebdabbddfc96450269c19ebe295758be5"
    sha256 cellar: :any,                 arm64_sonoma:  "47a9990f848ebfc3db24fbcb2171ac37f2121013696295b30b996ceae95a3973"
    sha256 cellar: :any,                 arm64_ventura: "d6a4b6553d2a67ecb09fda4a4cc6ea0b7eef36af9675583b0ce2e30ee7c4a491"
    sha256 cellar: :any,                 sonoma:        "2f8940b628185a6b29670d6dc760807248316b4e77c4c1e0cd868f26076bcc98"
    sha256 cellar: :any,                 ventura:       "dd88878b0d3d662a5e47d6e0d619b63017d3b21513576ff38fda4d4358d0a251"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c587b1c8d5b6d293cb2bac56910ed6dad2ef93f78ea1f68bb35b0036cba9cb4c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "66af0c8a4547b56860d7f77ddd48214727178c7ca4787f2917d1f1f281a3d93a"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  uses_from_macos "curl"

  on_linux do
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
    system libexec/"test-sampling"
    # The test below is flaky on slower hardware.
    return if OS.mac? && Hardware::CPU.intel? && MacOS.version <= :monterey

    system bin/"llama-cli", "--hf-repo", "ggml-org/tiny-llamas",
                            "-m", "stories260K.gguf",
                            "-n", "400", "-p", "I", "-ngl", "0"
  end
end