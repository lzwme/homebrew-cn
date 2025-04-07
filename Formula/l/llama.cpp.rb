class LlamaCpp < Formula
  desc "LLM inference in CC++"
  homepage "https:github.comggerganovllama.cpp"
  # CMake uses Git to generate version information.
  url "https:github.comggerganovllama.cpp.git",
      tag:      "b5060",
      revision: "0c74b04376b0b9efc096480fe10f866afc8d7c1c"
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
    sha256 cellar: :any,                 arm64_sequoia: "8b0746852eef4c658fc99adf03fe7e53c76175a2091d96e7adaaac96b4f61e08"
    sha256 cellar: :any,                 arm64_sonoma:  "962e3d20c3a44566301fef70b83e095c747b3b1b0ca4ce7467f45429aa0124d0"
    sha256 cellar: :any,                 arm64_ventura: "0848723086c89b95671b467bc619ddeefca641b4098e461aa670b39ebf5fd9c9"
    sha256 cellar: :any,                 sonoma:        "7073ddc3adb71d2eb3816117c9f10d52fc38842ab95697ddf5ed82abb6dc88a8"
    sha256 cellar: :any,                 ventura:       "6e522eb91f0832fc22c9e2f4adeae1f24fd873270895c5b865f18e36166448df"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2d9b393b2d870cc82dae34e90922b0a51a4ea29fe8d1c691d5570d314da01188"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dbb24872f2a9ad3a71a3be96af8a53acb75be1e24dc08e8c9bbe816c61a47c58"
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