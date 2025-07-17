class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://github.com/ggml-org/llama.cpp"
  # CMake uses Git to generate version information.
  url "https://github.com/ggml-org/llama.cpp.git",
      tag:      "b5910",
      revision: "6ffd4e9c442e99afac3d138543ebf86d5fc5ee03"
  license "MIT"
  head "https://github.com/ggml-org/llama.cpp.git", branch: "master"

  # llama.cpp publishes new tags too often
  # Having multiple updates in one day is not very convenient
  # Update formula only after 10 new tags (1 update per ≈2 days)
  #
  # `trottle 10` doesn't work
  livecheck do
    url :stable
    regex(/^v?b(\d+(?:\.\d+)*0)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "1106df7926b9b6f5d450103996d584a1caa3f8a8aad5ac149dcb3a1f24d55441"
    sha256 cellar: :any,                 arm64_sonoma:  "47694cf7d3e2673a2fa1378987817c8c2041b3a79b7e24a4be16aedbe9ce7b40"
    sha256 cellar: :any,                 arm64_ventura: "3ee9d6f6d6bc58ae9f67ea39d91148ffb170beec36d6faf93da8963ff13ed636"
    sha256 cellar: :any,                 sonoma:        "47a44c784c93c7d1497d51ebffe7cdda13f3dfd09dbfce37e67929870508f050"
    sha256 cellar: :any,                 ventura:       "aeaa95cb4fadad2e91d5a5d15dbd62e1054bc69db5c5d486aaf16ad845dc6064"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "245aff2b1a7a70870796818fe62b6ff7e7bec736cd9e1b6224900d2b453dd008"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cef8f70aaad89183ff08b3a03360afce029f7e581d06cdc76d67b1b9e10feced"
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
    system libexec/"test-sampling"
    # The test below is flaky on slower hardware.
    return if OS.mac? && Hardware::CPU.intel? && MacOS.version <= :monterey

    system bin/"llama-cli", "--hf-repo", "ggml-org/tiny-llamas",
                            "-m", "stories260K.gguf",
                            "-n", "400", "-p", "I", "-ngl", "0"
  end
end