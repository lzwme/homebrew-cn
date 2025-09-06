class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://github.com/ggml-org/llama.cpp"
  # CMake uses Git to generate version information.
  url "https://github.com/ggml-org/llama.cpp.git",
      tag:      "b6390",
      revision: "a81283820a466f2ace06ce4d4bc9512761f9365f"
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
    sha256 cellar: :any,                 arm64_sequoia: "248aa122c762c68606bd4ec629477e48eccf644c1afcbc8b33018fc26dadbe88"
    sha256 cellar: :any,                 arm64_sonoma:  "6c2e59360f4532cafb0111203bd38a1bc2aef24fb503dd998102dbd1d6b5e7ad"
    sha256 cellar: :any,                 arm64_ventura: "9f20f002d6e46bfcc92530d847d6bdc42122812edf3664a29c1636f3c1ec492b"
    sha256 cellar: :any,                 sonoma:        "bc5b1046224a64cb336c5b22f5c498d345a8ba91684c2405928be9ede368f4f5"
    sha256 cellar: :any,                 ventura:       "0c82f5e0a1bd56f2bd03e73fd7b9b520f5d6f3eb0be6d833ce41a018bbc918a3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5def6d6bacbc5e1ad0bdcf0c4085a3016768be599cdde649f73089a43712473a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1a8216e10537febb3435c94ba4f460bca4ca13dcbad09cd4fc50213ed1accac6"
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