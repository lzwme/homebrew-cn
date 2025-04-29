class LlamaCpp < Formula
  desc "LLM inference in CC++"
  homepage "https:github.comggerganovllama.cpp"
  # CMake uses Git to generate version information.
  url "https:github.comggerganovllama.cpp.git",
      tag:      "b5210",
      revision: "fb0471d1753824e75474c24f82fbdd54c94dceda"
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
    sha256 cellar: :any,                 arm64_sequoia: "edf976d5bff67c44542a2684076ec8c217942275bbedc344fea16133867378d7"
    sha256 cellar: :any,                 arm64_sonoma:  "cf575390904996486be9a4a6b1d45878c609fe56e2516d677023f68a9506b6d2"
    sha256 cellar: :any,                 arm64_ventura: "5faa3807c49b39d1df66fbd7783ba9d962c2151f05e863719cd91dd56da25f4a"
    sha256 cellar: :any,                 sonoma:        "1d041acbc8e25f9a09f248b24b74d27dcbaa1436772312cc1b7c25de99501e81"
    sha256 cellar: :any,                 ventura:       "4a3b6311821fbcfbdfaaf86ee021f6876ad3195b0f195099503e984cc33d64dd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ecc46d0cfecbf55bd3e409677e11a49231de364460344041633789142a42d11d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "67d1349f217f9f7afba08bc94a1a6d4a96d911abfe1605c7f22e44df7aa8fb5a"
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