class LlamaCpp < Formula
  desc "LLM inference in CC++"
  homepage "https:github.comggerganovllama.cpp"
  # CMake uses Git to generate version information.
  url "https:github.comggerganovllama.cpp.git",
      tag:      "b3667",
      revision: "581c305186a0ff93f360346c57e21fe16e967bb7"
  license "MIT"
  head "https:github.comggerganovllama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?b(\d+(?:\.\d+)*)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "55d36c5bb590105f5f97d495058aa0d7648f315dddf6e9bc6f7dcf6911fc0623"
    sha256 cellar: :any,                 arm64_ventura:  "293448fe3bbefcd6c1a0329183c7f4600f4e00866293bead6384d42faf0c32dd"
    sha256 cellar: :any,                 arm64_monterey: "5eb93f0f7a54f9958029f4f86019d3dac9d3f761aa983a9c77826796eb4bbb57"
    sha256 cellar: :any,                 sonoma:         "97373e14a62fda37f263dd8a66dba076f86f91fcb2b283ee6a9c37baf8c9db07"
    sha256 cellar: :any,                 ventura:        "d555953ac85bcdebba230184d2c637bac5c4e239072a2cd2ac11b03c91949cec"
    sha256 cellar: :any,                 monterey:       "91dfc58680d4e6a8242fbe4ea68d97266efce0405a82f2202e166df8963a66f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9de37ce89107f15a530379119f65014f21340060b56c5beb3d284788c5260f5f"
  end

  depends_on "cmake" => :build
  uses_from_macos "curl"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openblas"
  end

  def install
    args = %W[
      -DBUILD_SHARED_LIBS=ON
      -DLLAMA_LTO=ON
      -DLLAMA_CCACHE=OFF
      -DLLAMA_ALL_WARNINGS=OFF
      -DLLAMA_NATIVE=#{build.bottle? ? "OFF" : "ON"}
      -DLLAMA_ACCELLERATE=#{OS.mac? ? "ON" : "OFF"}
      -DLLAMA_BLAS=#{OS.linux? ? "ON" : "OFF"}
      -DLLAMA_BLAS_VENDOR=OpenBLAS
      -DLLAMA_METAL=#{OS.mac? ? "ON" : "OFF"}
      -DLLAMA_METAL_EMBED_LIBRARY=ON
      -DLLAMA_CURL=ON
      -DCMAKE_INSTALL_RPATH=#{rpath}
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