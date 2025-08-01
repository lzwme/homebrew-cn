class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://github.com/ggml-org/llama.cpp"
  # CMake uses Git to generate version information.
  url "https://github.com/ggml-org/llama.cpp.git",
      tag:      "b6050",
      revision: "784524053d986255e383dae45235e4f76c6792a7"
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
    sha256 cellar: :any,                 arm64_sequoia: "d9c2ecf7ca818ad3be50d91da52d48b2a1f6b505bd01598d31b7d98ed75585f1"
    sha256 cellar: :any,                 arm64_sonoma:  "b3d12a38d05c73d69f186da85a86056614f870bf4b46573fabfce86e651dceb7"
    sha256 cellar: :any,                 arm64_ventura: "1f680bee9b24a520a73592792dc6d9087f78ab8a7ce2ce9b82e3e67e92b48c56"
    sha256 cellar: :any,                 sonoma:        "d635e37092e6cd42ad01a4e0ef88b5562e9f1af66b0f0cb23b31e1a133681c63"
    sha256 cellar: :any,                 ventura:       "eb8093aae0ceeb5a0b72f542e1c6f41ad82035e2548d5ecdd5a263dbd715ab81"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a7873e0407722ba100658f51ea532924ef38265544407332d2cb172bac14ba09"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "24d6418e6bf88d10b9c33ade59b155569c1de65c803e5a7907f063845964f774"
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