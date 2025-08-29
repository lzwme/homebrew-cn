class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://github.com/ggml-org/llama.cpp"
  # CMake uses Git to generate version information.
  url "https://github.com/ggml-org/llama.cpp.git",
      tag:      "b6310",
      revision: "c8d0d14e77c3c45df5cbbddde9c2b4c377ec4e7a"
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
    sha256 cellar: :any,                 arm64_sequoia: "519cd6a15b168fbd9e63f34cb3d7e581cc244eddd8c7717eb7648cc9ae3fa6c3"
    sha256 cellar: :any,                 arm64_sonoma:  "c8d6f7132756fb15d680609f50c84a00e4599bd3a3ea40908353910fcca49d1e"
    sha256 cellar: :any,                 arm64_ventura: "a8d4d25c84ccd87c7c7eb8f2babc4be49f0c30c8ab026a70fb7631bf07d970dc"
    sha256 cellar: :any,                 sonoma:        "fde6e38391f602caae708de846bb3f25e37f3e78caf9a8dff63800b95761933d"
    sha256 cellar: :any,                 ventura:       "c9cb268dd7fce34d7f324249742ada7428682026262d9179d1a0f1b2285bb5a0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8320d9906dab4e0b7b317c6374ae78cdb86de2e6fee486986de4ce8b8c6b0fcf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e1942e593425e6c2706c5ef68625baab69b21ce0591dfabc4ebad5d05f445f1b"
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