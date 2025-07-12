class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://github.com/ggml-org/llama.cpp"
  # CMake uses Git to generate version information.
  url "https://github.com/ggml-org/llama.cpp.git",
      tag:      "b5870",
      revision: "0d5375d54b258ec63edd1fb5d58c37d58ce8be8b"
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
    sha256 cellar: :any,                 arm64_sequoia: "47e6ee7d85511f11325a86087eeafba49ee367b1055ab17d678b75158a29e782"
    sha256 cellar: :any,                 arm64_sonoma:  "f9f2de5ed7958665aa5e5b4d40306976ab3137f1f63742e25eb0348fcc4c6a7c"
    sha256 cellar: :any,                 arm64_ventura: "be4da9e81978d371ddc7a742492a6dfc4992b0460d7cd7ba260bea73a96e505e"
    sha256 cellar: :any,                 sonoma:        "7e0f5af73e656e9ed2999e2f6fab479f8873c309eb75aa5c77360c9f08bf060d"
    sha256 cellar: :any,                 ventura:       "cc9b054f8b22d1eb3f7465d9c703c5553bbb0923f23abc1fdb38e7d6a9fbfef5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f6badc7976ed38daccaf61d62b0e4ad93e2e8fdb1add83d5dc024dd3eb20ee9f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "948b699c27369639c933e5721cab4a4ddb017b51e161fb11688f0e8754f5e5cb"
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