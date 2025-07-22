class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://github.com/ggml-org/llama.cpp"
  # CMake uses Git to generate version information.
  url "https://github.com/ggml-org/llama.cpp.git",
      tag:      "b5950",
      revision: "c2e058f1b4e799f1be085560c1bcef95b7b5ed02"
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
    sha256 cellar: :any,                 arm64_sequoia: "0de65bb2af60185f2dac9be8b5e8b80c09a8f88584311b6e610ccb41f7445d0e"
    sha256 cellar: :any,                 arm64_sonoma:  "d0c128cf1337aa32613473dea9875c00b47b68f6b80cbec920392dab249e0aac"
    sha256 cellar: :any,                 arm64_ventura: "2b179bde5608989d042e87a06c87081eef95d2487da7e76ce860be6b65c5fd31"
    sha256 cellar: :any,                 sonoma:        "ae81d01b7b5fcffdd945fcefeb708bbd3c76a033f35f8b4f540043c864784a1b"
    sha256 cellar: :any,                 ventura:       "9a7a7de9780542e3dfa766b4ffcdb6259781533c6e4a67b7c6564ccfafc9192d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e59ff0e7dfe3a0464409761f6be9d75c0d5fe89a530fa734a029f9a8ecca3628"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ffb1c413a504758794202753b4536a4686da5697faaaa9cc1d65bc2f6ac8d90b"
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