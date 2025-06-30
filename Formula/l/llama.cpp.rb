class LlamaCpp < Formula
  desc "LLM inference in CC++"
  homepage "https:github.comggml-orgllama.cpp"
  # CMake uses Git to generate version information.
  url "https:github.comggml-orgllama.cpp.git",
      tag:      "b5780",
      revision: "caf5681fcb47dfe9bafee94ef9aa8f669ac986c7"
  license "MIT"
  head "https:github.comggml-orgllama.cpp.git", branch: "master"

  # llama.cpp publishes new tags too often
  # Having multiple updates in one day is not very convenient
  # Update formula only after 10 new tags (1 update per ≈2 days)
  #
  # `trottle 10` doesn't work
  livecheck do
    url :stable
    regex(^v?b(\d+(?:\.\d+)*0)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "b0d9cfa92f5e7ef5e951bb8730d9d031668741e2fefa6cba3c8c37536069b623"
    sha256 cellar: :any,                 arm64_sonoma:  "83b47adeaedd0d8d59627462fb339b0ffe61c81a280fb72dfab065dc91eed10c"
    sha256 cellar: :any,                 arm64_ventura: "5700034b4e32dca91b1cf8890b4fd41749cbad22fc9a8e2e849dae6a9d11b5f0"
    sha256 cellar: :any,                 sonoma:        "1c7ad99dda26426f1a92bec02756b281dd482900274dc4270fbec2a05247d7c9"
    sha256 cellar: :any,                 ventura:       "e1b16f4a57e80d8800213a1db35eba2a588ee65f5991ea1f2a5630b692fca82e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8bc657dbfc94ed8928aa2e5ae0dc681c92e56e673d44f3a8baf5e56f3458bc3c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3931b19851a5bffd19fcf760daa7d1377b30474746eeb8a9eb4480856598a5b4"
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
    system libexec"test-sampling"
    # The test below is flaky on slower hardware.
    return if OS.mac? && Hardware::CPU.intel? && MacOS.version <= :monterey

    system bin"llama-cli", "--hf-repo", "ggml-orgtiny-llamas",
                            "-m", "stories260K.gguf",
                            "-n", "400", "-p", "I", "-ngl", "0"
  end
end