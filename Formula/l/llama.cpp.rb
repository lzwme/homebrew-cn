class LlamaCpp < Formula
  desc "LLM inference in CC++"
  homepage "https:github.comggerganovllama.cpp"
  # CMake uses Git to generate version information.
  url "https:github.comggerganovllama.cpp.git",
      tag:      "b5220",
      revision: "cdf76586b23c67abd3ca064ee2c084c57ae240bd"
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
    sha256 cellar: :any,                 arm64_sequoia: "d6119a606c1d8ed2f5e04311091176a0d5931176e9ff1634c2649e6a395d2776"
    sha256 cellar: :any,                 arm64_sonoma:  "a897450163023d8a82f72ec6b66c56215f99c6ae2278784b655615033870929d"
    sha256 cellar: :any,                 arm64_ventura: "69dfbfc9340b2bad3086a36d0636ac0e77a1866e24ecbdd62b76ab20e8d25526"
    sha256 cellar: :any,                 sonoma:        "3ce9dfbd3390febba2a35f57a2efcd4549459393b8b6d472456643a24d79a86e"
    sha256 cellar: :any,                 ventura:       "1b38fe67c049bfa5bde2f2c700efc0fadb9acb6c1b8ebeb6eacf8d8ee081dab6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5bc871a719a097da47515aacaf6176d6b6050ccbb6592b586eabeb02ae4028eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e6e4839ab76e767b5c42179b6b684f5a1e09e20007e232176de8a855f1ea9d60"
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