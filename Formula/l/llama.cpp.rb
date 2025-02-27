class LlamaCpp < Formula
  desc "LLM inference in CC++"
  homepage "https:github.comggerganovllama.cpp"
  # CMake uses Git to generate version information.
  url "https:github.comggerganovllama.cpp.git",
      tag:      "b4783",
      revision: "a800ae46da2ed7dac236aa6bf2b595da6b6294b5"
  license "MIT"
  head "https:github.comggerganovllama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?b(\d+(?:\.\d+)*)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "80ae845574005872b4193b3afec17a5422b3c7c5c17eaa38aed7fd93bf78ece6"
    sha256 cellar: :any,                 arm64_sonoma:  "254e9232e7a0eab0ce314a1af9b30c428862d88d634f6b630c8be77e4ae657aa"
    sha256 cellar: :any,                 arm64_ventura: "7089d8666dd15e53a66441c20c2ed68b84902c5859bceca6b1195073d125d9c0"
    sha256 cellar: :any,                 sonoma:        "1f9d24ec4794d1b1a438421c12506b6ddb3ba9920eeb42fbbccc2aad1bbf2bba"
    sha256 cellar: :any,                 ventura:       "b481507a40323dcbf2fad5ac5ecbcf1c77f061ddc7010fe98520e4893fddc463"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aa0365ea5771c97b5be9d0c6f5a8ce53e4ec9f7fb69697d215ec679a1fdbdb14"
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