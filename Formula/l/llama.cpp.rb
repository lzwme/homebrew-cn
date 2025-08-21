class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://github.com/ggml-org/llama.cpp"
  # CMake uses Git to generate version information.
  url "https://github.com/ggml-org/llama.cpp.git",
      tag:      "b6210",
      revision: "a094f381432d92c4bf92d2d6167284316ba73a62"
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
    sha256 cellar: :any,                 arm64_sequoia: "4b5333c7c7345acfc2e1096b236214ceeefd5bf7016050d3121dc7385a576575"
    sha256 cellar: :any,                 arm64_sonoma:  "4da65a4627b606910435067b3015195fa0ab970d1012d2d6cb4cddeea32dbd5b"
    sha256 cellar: :any,                 arm64_ventura: "033ac47e801627cfe2570ee48f3727c2759bc16fe62263a15e2423968292dbc5"
    sha256 cellar: :any,                 sonoma:        "4aa10c61d642f6a68af169b593d75b961b3880c1d28d5ed74d4e13d93d104c5d"
    sha256 cellar: :any,                 ventura:       "e2e744832189df41242590d333f7e1b26285f451c77eb4da86972d6a713aa330"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "08db668168325bc29ae740009ef0e22c4b0024b4b93051680fc1241807d2c953"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9fdbc9b6ce4e29fcd20b77ff8eb10721b70185906c7c31e2ddc39c30368f150d"
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