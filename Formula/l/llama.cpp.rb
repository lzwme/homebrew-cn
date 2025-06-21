class LlamaCpp < Formula
  desc "LLM inference in CC++"
  homepage "https:github.comggerganovllama.cpp"
  # CMake uses Git to generate version information.
  url "https:github.comggerganovllama.cpp.git",
      tag:      "b5720",
      revision: "8308f98c7fb778e54bf75538f5234d8bd20915e9"
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
    sha256 cellar: :any,                 arm64_sequoia: "6c42ca700f60a3d1141d6307d2da1f49e14ab15ae06017bdd9542afe0c997902"
    sha256 cellar: :any,                 arm64_sonoma:  "491260e5f4f90e3cea25356fc3b856d64193c7f63b8afcb4d29c4ef22728ab0a"
    sha256 cellar: :any,                 arm64_ventura: "f021caf26e68a2265cf80f70b2961261874557ea90838467b19c6b99288521d4"
    sha256 cellar: :any,                 sonoma:        "fd6debbdff7010bc4b3a296889538e13834fc21ae523bbaf5666f3b7954f512b"
    sha256 cellar: :any,                 ventura:       "78d9e95bfc57f70d43ddb37e4a9303d5a91e901394c29a307ac17698a4650963"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b87ac7bf4e1ad9ba2b7b8044cb2b41d9a2cc7b677d94575b29abdd7433b17946"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b01684cf9f96c3d3466abf65d5d85e0a904bfd437955de865fc1815096ee63a5"
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