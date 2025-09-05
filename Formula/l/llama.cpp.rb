class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://github.com/ggml-org/llama.cpp"
  # CMake uses Git to generate version information.
  url "https://github.com/ggml-org/llama.cpp.git",
      tag:      "b6380",
      revision: "a68d9144262f1d0ef4f6ba7ad4a7e73e977ba78c"
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
    sha256 cellar: :any,                 arm64_sequoia: "b3272f1d9246408c7cebdcab98fce6f7cdb50353d92ddd3dd4d9c3612782d894"
    sha256 cellar: :any,                 arm64_sonoma:  "eb5f9dea0745f8e1d6672b4bf7a77c29937b9cd640b630c1506efa8f5773c5c4"
    sha256 cellar: :any,                 arm64_ventura: "7357945d29ec61969958042eefc5e6b500a0d477706de4ddbeae45597de22751"
    sha256 cellar: :any,                 sonoma:        "0e7bd1973285c2a9f6f2344e05cfe0abb625d5f2e1b75ae6fef465c8a7edf4ea"
    sha256 cellar: :any,                 ventura:       "7082a908cef89b6357cc856c28945f6b8b33ad29b8eaea35ff5523fd391c2846"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b32343ba26ab212e0167b4f261a36b032c14e20fd21b361177d46b07bbc0f50d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e8d9ff8e30ef9f5118914dcf50e46fa1990824fce4fea320b82dc29d4564eed5"
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