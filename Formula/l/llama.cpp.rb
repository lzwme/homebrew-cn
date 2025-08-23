class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://github.com/ggml-org/llama.cpp"
  # CMake uses Git to generate version information.
  url "https://github.com/ggml-org/llama.cpp.git",
      tag:      "b6250",
      revision: "e92734d51bcb82cc35f0a6b5a14928f0036b2c90"
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
    sha256 cellar: :any,                 arm64_sequoia: "e5403c757afb6a0acebe354bde6b7455ef18b46708b38ed95ba3027ec1c1e2a0"
    sha256 cellar: :any,                 arm64_sonoma:  "b3e22c90cce844adda26bb432337df5ce15c7bbad406fd78927af984a2457dca"
    sha256 cellar: :any,                 arm64_ventura: "2fd76338b511921b71b0481e41f34821829fbb434dd06cd66ab443688ea6149b"
    sha256 cellar: :any,                 sonoma:        "b90fecc08d17f11497d7a8d96ec45b4d6145fe08c762871434e8e8f4fff89b55"
    sha256 cellar: :any,                 ventura:       "60c17669334a25a443d5df1954e62c78711df6e838ecc66e7bc0af74dfd116f2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "70535abc75b026f3e1038cdd3fc21dd2d5be55a508a469b287a99b9bf39cc8a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ff11a862ebc1d049bdcb431359841f806e94db1f4ae8721d64c4d8ab4add5fec"
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