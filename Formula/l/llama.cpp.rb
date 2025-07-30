class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://github.com/ggml-org/llama.cpp"
  # CMake uses Git to generate version information.
  url "https://github.com/ggml-org/llama.cpp.git",
      tag:      "b6020",
      revision: "0a5036bee9cfb946870689db4400e9e0d17844c9"
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
    sha256 cellar: :any,                 arm64_sequoia: "f9e91155d8d976d8d7566ab8784709e96f5749976477e56a7914b3adc3d1db9f"
    sha256 cellar: :any,                 arm64_sonoma:  "0c2fc610b4bdbaf7ed3bfc9d90de09e9c8fb84e61a6bb9bda43704de9082349c"
    sha256 cellar: :any,                 arm64_ventura: "eb1f1e4db7304b6453a2f08b3e1929fd1b1bb28dfa466dc24400c4569c0a21b1"
    sha256 cellar: :any,                 sonoma:        "76f654c75438c88f2cff35eb4cb9e29fbd3783227c42bd03f3f1d035d2e45805"
    sha256 cellar: :any,                 ventura:       "3bf8306d113448a6741bed36ea51e8fa1868aff451496b092c2d3b1cd28f3cba"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "577efd2abda7d505976ea25c7ccf5c943f8ac01f72c3183a9f38d7918784ccf5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6ebdc092c3ea9fe0eae2e4476996bd0b0ae50ad3cb24fe8f97bce41c777a7f77"
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