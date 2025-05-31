class LlamaCpp < Formula
  desc "LLM inference in CC++"
  homepage "https:github.comggerganovllama.cpp"
  # CMake uses Git to generate version information.
  url "https:github.comggerganovllama.cpp.git",
      tag:      "b5540",
      revision: "291f2b6913c7ef8350dbf0e77da38f7af131a08e"
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
    sha256 cellar: :any,                 arm64_sequoia: "48776929c28d37fe3e94f314e00825ff99687fe324829fc293607c0e72a4d490"
    sha256 cellar: :any,                 arm64_sonoma:  "9c7562949678ade1e0141472fdace4d8dc26e9fddf4c04acef991b043c9871ad"
    sha256 cellar: :any,                 arm64_ventura: "539f60efceaadb13970629112ae3c677c980d9813d79efbd317ae290432d9cec"
    sha256 cellar: :any,                 sonoma:        "1d948861ede4c3899dc8da8fc6b930f571414bf07c1904aa4a39e98dfd7054fa"
    sha256 cellar: :any,                 ventura:       "e6ef36f01e9f7ba387e08f007dfeadbf7101e23050b0a9b08c808c2b3bd13cee"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5c5403e7bcfa39216873a0760c221e771198301ea658554cee29c1fd127d81a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2ea89025c3057bec083b38136d51b1d69a92e69fa212cdc1d514d67b0e9ffefb"
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