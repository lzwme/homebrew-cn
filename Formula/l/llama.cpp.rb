class LlamaCpp < Formula
  desc "LLM inference in CC++"
  homepage "https:github.comggerganovllama.cpp"
  # CMake uses Git to generate version information.
  url "https:github.comggerganovllama.cpp.git",
      tag:      "b4394",
      revision: "16cdce7b68218959e0658e2f95b4572573d5008e"
  license "MIT"
  head "https:github.comggerganovllama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?b(\d+(?:\.\d+)*)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "38ee5559020f80ff42fd8a52b2e304a4c0426669b72f56dda34d4eb4ae857882"
    sha256 cellar: :any,                 arm64_sonoma:  "6d06cca78f16cb6f8ccb9194fb35c0ddab02a8d385fea8a47a1a3f62bdc1babf"
    sha256 cellar: :any,                 arm64_ventura: "6deae02d0d51cb59371c4e7c22484f5296b5dfc846a8cee1d93bb8a9683684cf"
    sha256 cellar: :any,                 sonoma:        "74019bdbf6516fe9a465bbeace5cbfd45d061ad0a8bc98cc2b1f4098cca37b8a"
    sha256 cellar: :any,                 ventura:       "c700c45597ed6d5adabefe4da2b88e4537cd3e37f8e2a54d58a41394bc0f37ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cf2f5bcdf38b9c774b7a1be0397a936c382c876768ac94fed9ca4733bd7fa14b"
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