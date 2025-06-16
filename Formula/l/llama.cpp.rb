class LlamaCpp < Formula
  desc "LLM inference in CC++"
  homepage "https:github.comggerganovllama.cpp"
  # CMake uses Git to generate version information.
  url "https:github.comggerganovllama.cpp.git",
      tag:      "b5670",
      revision: "2c2caa444341d99c87ff153f142c2d4762a776a2"
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
    sha256 cellar: :any,                 arm64_sequoia: "15005bbaa9b5f254604634a82fa2ecfb75af11d14ef4ad4d1fb055ac107ffd11"
    sha256 cellar: :any,                 arm64_sonoma:  "eaf1dbabb726a33c87717a137fb733e7c4eb4276d05a2eac4acada9c9d6cd6b4"
    sha256 cellar: :any,                 arm64_ventura: "147295eb783b108ad93d7daccb20e03864c4aed0bf46b5082e5382c7c3c10ce4"
    sha256 cellar: :any,                 sonoma:        "b115f82a4d3ecb50a6d3975468c3c5bcb378b3ea1f0d717a7eba83890e643d49"
    sha256 cellar: :any,                 ventura:       "a2ac504e95f27a748c003830e580bd1b6836c4a9db55fe611608ea811e8d5a6a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "37b7bb9d686128ea4610acd32131d88c7abcadc5eb182ba9cf956c9e58a7f8a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3e9ab199b5f63d3d3aa1f9cb43f8744050417df3cde702819f08e5d80d171630"
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