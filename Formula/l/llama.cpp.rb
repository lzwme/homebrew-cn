class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://github.com/ggml-org/llama.cpp"
  # CMake uses Git to generate version information.
  url "https://github.com/ggml-org/llama.cpp.git",
      tag:      "b6240",
      revision: "54a241f505d515d625767b993bfd573ecee306b9"
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
    sha256 cellar: :any,                 arm64_sequoia: "0e9fe007219d6a344439f4d947edd76bc404cf6a0b07517bee3710b313b44f47"
    sha256 cellar: :any,                 arm64_sonoma:  "4934eb80f96e4fc603f01c89416ab8ab83dd5788f56513f5418a79f203782bff"
    sha256 cellar: :any,                 arm64_ventura: "8ef9cc79b63468d55f762cfcca3bf9d692fd72a4baa3fc357aa7098822769af4"
    sha256 cellar: :any,                 sonoma:        "7d5ff052e407dc5c3c6275de7e31ed814f2ffb029ab8abe483d21e9ba2169b26"
    sha256 cellar: :any,                 ventura:       "cab0bd5667d38ed7533b2e95b1d1d4092b2b88dea347d58e3767dfc5bfc46234"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "69837fa4ce8adddbda1643fc71ca939fc8953223dd8e62a031d1b6323afdd973"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "58dbf7350ec9a1296c949e264909257ffe7093e629e7fb621f9ff5dc95bfc0c4"
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