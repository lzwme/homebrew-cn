class LlamaCpp < Formula
  desc "LLM inference in CC++"
  homepage "https:github.comggerganovllama.cpp"
  # CMake uses Git to generate version information.
  url "https:github.comggerganovllama.cpp.git",
      tag:      "b5430",
      revision: "c00a2634bec49805c6b31438b1a6006a2bd793cb"
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
    sha256 cellar: :any,                 arm64_sequoia: "41840e8ebef2ce34c25d4d199a253c08ad5cc69c7a27c568a86981dfa4440c67"
    sha256 cellar: :any,                 arm64_sonoma:  "bf3b54b812bf3da4364a545cbf44ebe62688d8269a9989e145a7ad907123a127"
    sha256 cellar: :any,                 arm64_ventura: "35b9c9a7aff64f3eee8ee05dbfd7ae5a51fbd8b044275843b754429c1f5fe180"
    sha256 cellar: :any,                 sonoma:        "8d8e239eed1a0b50847f379187ea96498d732418159003f8d4883f1232d5af1d"
    sha256 cellar: :any,                 ventura:       "6da9009707914d30dcc1d45f125821df880aabf997fb320249d41365e1664188"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a270fc33fac328a7bf04ed415d19200b1ea610cec87ea72328630e3b4dca0c70"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ccdf9aa284acb7af85be6ad2f2de34884fadcef9203930d85fa434706bd0d815"
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