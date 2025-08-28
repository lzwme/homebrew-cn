class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://github.com/ggml-org/llama.cpp"
  # CMake uses Git to generate version information.
  url "https://github.com/ggml-org/llama.cpp.git",
      tag:      "b6300",
      revision: "47373271f971aa5a0a6462b286f4a7b5bd4ba644"
  license "MIT"
  head "https://github.com/ggml-org/llama.cpp.git", branch: "master"

  # llama.cpp publishes new tags too often
  # Having multiple updates in one day is not very convenient
  # Update formula only after 10 new tags (1 update per ≈2 days)
  #
  # `throttle 10` doesn't work
  livecheck do
    url :stable
    regex(/^v?b(\d+(?:\.\d+)*0)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "26bf7f35817009081d9e465bb207e806c85d3a03d659b7cc8ad5760a2b867eb2"
    sha256 cellar: :any,                 arm64_sonoma:  "22f648f16dcaa1931a963141d12aa23f857a4cf88a102badaa16d005f380d434"
    sha256 cellar: :any,                 arm64_ventura: "55900a0293a7f00301e6080714037f8a383aaccbadb806f536bb9cdc0cb1f7cc"
    sha256 cellar: :any,                 sonoma:        "c0e0fc3a4fb6fe0db8cf58fb475967038021228528262f6f5d9f88d38a6d9e9b"
    sha256 cellar: :any,                 ventura:       "02af01389e840516f78c9241cd783d4b45852edad6076cbb800095a6b5f7c884"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a1bc57c0e1a43bff552399f1301c58be5d8b4e657736e949127b090823805059"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fa752049650ab003b3a7c17385dabb5abacb0ab7db18f804410a33b4ed8db814"
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
      -DGGML_ACCELERATE=#{OS.mac? ? "ON" : "OFF"}
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