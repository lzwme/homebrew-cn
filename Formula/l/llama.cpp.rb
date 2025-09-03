class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://github.com/ggml-org/llama.cpp"
  # CMake uses Git to generate version information.
  url "https://github.com/ggml-org/llama.cpp.git",
      tag:      "b6360",
      revision: "3de008208b9b8a33f49f979097a99b4d59e6e521"
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
    sha256 cellar: :any,                 arm64_sequoia: "d91aa920081757e089c18f8a5bca2d55aff87961b35081a00d42e073ccb88e1d"
    sha256 cellar: :any,                 arm64_sonoma:  "5db080f31231432db7f111d38a7286b4d57dc13312abd04444592fb7d2e1a61f"
    sha256 cellar: :any,                 arm64_ventura: "d86fe6362b7fd1e62341fb0f4c9396f489ebd8bd3a52424c7fde3c78589742d7"
    sha256 cellar: :any,                 sonoma:        "dc9fa273c63341028008898be0982a93f6a64862ea2140621c2877d63856d159"
    sha256 cellar: :any,                 ventura:       "004039296d054ae125eea76a1fa5777882a0ff49068fa805857e4c07d827c842"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e232651693b51771fd91551d4842e694c88d0ca41dd7ba6cb5bad22345bd0f2b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "13a552f4e3e0e5506b8488edb72ac90d13d3856ff55d714cb4c8e3fa526c415a"
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