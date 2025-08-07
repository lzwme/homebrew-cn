class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://github.com/ggml-org/llama.cpp"
  # CMake uses Git to generate version information.
  url "https://github.com/ggml-org/llama.cpp.git",
      tag:      "b6100",
      revision: "65c797c4fad4d9966695ac4b4a1560be44109267"
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
    sha256 cellar: :any,                 arm64_sequoia: "1bf1d8677b5421964faf6a8fea3088c33a8f421ddedd93f9fdf48f84d0c5f603"
    sha256 cellar: :any,                 arm64_sonoma:  "f4b565ecdfcb697d7e5dd8df4da0fcb91544b68c99c71a82ebf87b445a3ad3e3"
    sha256 cellar: :any,                 arm64_ventura: "d63b4dd8a9ee878aea1a0b20ac6fee255b999e4b951f22b98fc3b01ced09039c"
    sha256 cellar: :any,                 sonoma:        "03179e10c21c55253ff982e6c12efc1be200c5f8f8e9265827849e2b1b77bec8"
    sha256 cellar: :any,                 ventura:       "b43956ee6ee23f03a46c8e531454c5b4c4c9c41f7c15693a3e9d02c03bc45354"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dc6e19b682711902eead591f73dd781e88cdf545b4a86228b12a5ebabb528279"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0e34b4a98b95595bf0a01d573853b4176143a505fad8a358949096f7d86cbb72"
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