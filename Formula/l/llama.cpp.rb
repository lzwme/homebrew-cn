class LlamaCpp < Formula
  desc "LLM inference in CC++"
  homepage "https:github.comggerganovllama.cpp"
  # CMake uses Git to generate version information.
  url "https:github.comggerganovllama.cpp.git",
      tag:      "b5270",
      revision: "3bf785f3efa89ed28294fbf73054558a2b034bfb"
  license "MIT"
  head "https:github.comggerganovllama.cpp.git", branch: "master"

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
    sha256 cellar: :any,                 arm64_sequoia: "2288e3f79970b433791e5c667b365e3045801fc54090edaf437047da751c3c59"
    sha256 cellar: :any,                 arm64_sonoma:  "58525aacc23dd96df05ea44877e4399864b9fa046a10e1f62552fe297490039b"
    sha256 cellar: :any,                 arm64_ventura: "d6b0825b32bf18650c3908fe447b4c3b3b0cefd0560678fef3deb8c1370fb7eb"
    sha256 cellar: :any,                 sonoma:        "982240335fe476c2c7964d81c8a19a3d76d0ff21a02a409fe4de0df979813104"
    sha256 cellar: :any,                 ventura:       "64d5b71a0c1a422e2ce3331f38e0bed321af69fe86a72553f9a5ac4348e7db92"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a99c545fd51f1556068e9f5bc4f97a49a9595b20a792027227d30918d72247b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5f7c94d85b2639a941b9e53cf7e03e41279cf96357540a971771349c62469dc9"
  end

  depends_on "cmake" => :build
  uses_from_macos "curl"

  on_linux do
    depends_on "pkgconf" => :build
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