class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://github.com/ggml-org/llama.cpp"
  # CMake uses Git to generate version information.
  url "https://github.com/ggml-org/llama.cpp.git",
      tag:      "b6180",
      revision: "2e2b22ba6607414a5d619ac6d2f034b5b02214e5"
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
    sha256 cellar: :any,                 arm64_sequoia: "2d0b2e9bda7c79078d138f56027bb558c8a0aadbbbcb44a6c12fc52bf0cfe84d"
    sha256 cellar: :any,                 arm64_sonoma:  "ac1850db2d248be46f2187bb885b0fed9d112d8a851fade368445b9a4bfbb851"
    sha256 cellar: :any,                 arm64_ventura: "f643cda9a1462cadcd312b1a62d8199589761e50e5d1050c500fcdd140de646c"
    sha256 cellar: :any,                 sonoma:        "f3df173aa9774e11a54a8d6624ace8172223656ee58d1bfb8b3e26633962bffd"
    sha256 cellar: :any,                 ventura:       "cc390f9a8726ca57b9b15cb7be004fb34b8c6e210bc56562c2629d821f3d7498"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c33081b3e74a992c217093a32444a564c6666d9b4eebf87070721c3cb658f5af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "603942d7f2206c647b14a9fde0b4c872ffcf86d7f50732c3e390f49ee37c3b36"
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