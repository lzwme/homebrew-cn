class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://github.com/ggml-org/llama.cpp"
  # CMake uses Git to generate version information.
  url "https://github.com/ggml-org/llama.cpp.git",
      tag:      "b6150",
      revision: "b3e16665e14032d1276f9d0263acef8321b6f518"
  license "MIT"
  head "https://github.com/ggml-org/llama.cpp.git", branch: "master"

  # llama.cpp publishes new tags too often
  # Having multiple updates in one day is not very convenient
  # Update formula only after 10 new tags (1 update per ≈2 days)
  #
  # `throttle 10` doesn't work
  livecheck do
    url :stable
    regex(/^v?b(\d+(?:\.\d+)*0)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "5dc7f4f9536c8d5021c7674d9564d25f090d61b740e3a55eb41f342c6d2b89dc"
    sha256 cellar: :any,                 arm64_sonoma:  "3a138de9e79e506fbdab1d30f1c6e62cebd779cd7172b543dd7a4cf5929af703"
    sha256 cellar: :any,                 arm64_ventura: "fca877238f06ff2af19cee655e18063c22168a062442ca6d36aa8cc1ead15356"
    sha256 cellar: :any,                 sonoma:        "6b7644392ea30c6e73a22fe629af91fca2db91793a4c55cbb4784f552ce411bc"
    sha256 cellar: :any,                 ventura:       "ad2c6dd9e0f764203b6318976dcd604d87ca30c42279bc87beaa96b9eca0d8cf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c58ac309afbc8bb7324b8ac0e22c1b0d0d0cf7489de33315f83729664519ee4b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2bd28b5184fcde212b686951f66e18a2a8e63e6d1d993770b37ab0ab1f0b81a1"
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
      -DGGML_ACCELERATE=#{OS.mac? ? "ON" : "OFF"}
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