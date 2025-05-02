class LlamaCpp < Formula
  desc "LLM inference in CC++"
  homepage "https:github.comggerganovllama.cpp"
  # CMake uses Git to generate version information.
  url "https:github.comggerganovllama.cpp.git",
      tag:      "b5250",
      revision: "e0f572c8466e70d35cbd70ee536ad8fc83b2acac"
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
    sha256 cellar: :any,                 arm64_sequoia: "7eca8bd417ef0c02eb95373fc07674466d5e5fb33eca675124857469b31cc781"
    sha256 cellar: :any,                 arm64_sonoma:  "c8bdc00a0e070cd24de647bac97dc20e97282a66a7d447898d7dc1acd2750e5c"
    sha256 cellar: :any,                 arm64_ventura: "af929e8d7f111ac19192c6234b792d3b2a93d451a0c4bd6f732b3d9d68d24c47"
    sha256 cellar: :any,                 sonoma:        "8d9c736de23ee1939f7c4fb5a85983f36082dd86adbd034b868a037e4c8c2cbb"
    sha256 cellar: :any,                 ventura:       "6f64acc7398bb38de39791e43a433315d24752aec40c1040eef85f7783d1fdd3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4f1f205b9d53c3a20c37521b21a92127ac9c08ca4d23980de5b91bfd3824c02f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9692a3361f676797e2b0d4c44a250321b4e3999885d360c08788a658fb387dbc"
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