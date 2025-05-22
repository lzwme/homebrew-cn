class LlamaCpp < Formula
  desc "LLM inference in CC++"
  homepage "https:github.comggerganovllama.cpp"
  # CMake uses Git to generate version information.
  url "https:github.comggerganovllama.cpp.git",
      tag:      "b5450",
      revision: "d643bb2c798df9c2cd61067d2692b1cd417df402"
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
    sha256 cellar: :any,                 arm64_sequoia: "f04ea6020a4513db05230a26984b37316417c1ab7b80aa560237714f91933e5b"
    sha256 cellar: :any,                 arm64_sonoma:  "f420ab0a5ff6421ec4012c15ebb46fa372838bdd55a8d8affc9e9b756ebba862"
    sha256 cellar: :any,                 arm64_ventura: "798927f09b4ce71a88ba2ca092f092f0b1023e2d240591f3a65e8a0991323778"
    sha256 cellar: :any,                 sonoma:        "63d3c5814ca80c777992bc5515c9bfd8215027eb5833f7544044700fa319c2ba"
    sha256 cellar: :any,                 ventura:       "a89c8a9527b66cacb4cf122ef96f7b272f67b579a432a6e6654232003220d657"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "30e5bcef9cd8f356b286680020a20178c694c49b789e0ecd1c8b56148e38c9cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7ed535673fff5678c4dea82c0161f130e8afabc536a5dbb4839df749461ea805"
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