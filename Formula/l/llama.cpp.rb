class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://github.com/ggml-org/llama.cpp"
  # CMake uses Git to generate version information.
  url "https://github.com/ggml-org/llama.cpp.git",
      tag:      "b5920",
      revision: "d9b691081c04ec5fb0daa9d2b979f915c142963d"
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
    sha256 cellar: :any,                 arm64_sequoia: "898de4207d0be29611240e8da00fd58a35be976aecff8b6822515f4aadcff575"
    sha256 cellar: :any,                 arm64_sonoma:  "15de55a56d88462c64e122e635c0c709c47559614fb46328abe5bc224103e706"
    sha256 cellar: :any,                 arm64_ventura: "606d4b4fd4909898986120cb651ad1ab51f39ea7b641d61e5f58d498704cadc8"
    sha256 cellar: :any,                 sonoma:        "2186c5b60c2e65e7cead6ed01200ef719889cb5f43eaf27ab459dc5b802a290d"
    sha256 cellar: :any,                 ventura:       "4a60334d079bab4e95c39e0778949ab73c0ba7edabdabcedb58a4bd597525d9a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7851193bdb180976ef02c7b6165da28acba5d4a4f15e9851d255ae38efbbfb5c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "210bb3a55f0ebd33160390a025c982a4f26d77a627401389961b91845909b059"
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