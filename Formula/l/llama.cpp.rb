class LlamaCpp < Formula
  desc "LLM inference in CC++"
  homepage "https:github.comggerganovllama.cpp"
  # CMake uses Git to generate version information.
  url "https:github.comggerganovllama.cpp.git",
      tag:      "b5230",
      revision: "416313773b53585fddcafbcb914cbbfbaeb94b1f"
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
    sha256 cellar: :any,                 arm64_sequoia: "abd346f8e47bda0d94206daaf44745347df6ef075728ca902b8e836854600dcb"
    sha256 cellar: :any,                 arm64_sonoma:  "dcb0c9306dcb372e7a6a6aa26c20fc23b392f3562b08fac17a6bcf7049a24944"
    sha256 cellar: :any,                 arm64_ventura: "7dde970d1e6fc676c223b895bccde4488010488f84466a8fe0c3ddeed53df05f"
    sha256 cellar: :any,                 sonoma:        "15f72c3b42377560159864f9f10756e55884f2c9ac6a34dc9ef84ca1290e8c0a"
    sha256 cellar: :any,                 ventura:       "024e1fa8a2aa281cc46429c6df4dd109ad23a514da5a54271d1bcbcaafddf350"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "611d77754f9b07c82c8bc83d265f8799088b4a61504feef6ba7445a7f6ca877f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "12c99fc44863ea2de69582fd483f64c92f32ade287b188d3e7b479940975fa2d"
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