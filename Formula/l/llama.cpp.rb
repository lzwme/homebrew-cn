class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://github.com/ggml-org/llama.cpp"
  # CMake uses Git to generate version information.
  url "https://github.com/ggml-org/llama.cpp.git",
      tag:      "b5900",
      revision: "10a0351a97c25471aea0bbde9cca54d32d163eec"
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
    sha256 cellar: :any,                 arm64_sequoia: "dcc7e56ac5502c7080e6fb2d879bfcf6bd1425a75ab3c6339333d93802bd18d5"
    sha256 cellar: :any,                 arm64_sonoma:  "e5b8aad4fa7ee64651ca4a608b3b2ee9061f45ad1b6fb519ab1e93fb29522bf6"
    sha256 cellar: :any,                 arm64_ventura: "56cc4a9adbbc700c33e2582cb9bba79947b54a7f0a95795316204c007036d27c"
    sha256 cellar: :any,                 sonoma:        "e0fe11d9fe26721d7fb6d48445e2a63932ad2f88df07b83dd2d6bc27a0b56773"
    sha256 cellar: :any,                 ventura:       "62f3c8c7e8bc05cefd99c008d45840f50e36f2f965d879ba76d01f74fc51a705"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c1f7d848ef24dd3434c5fc53651aef6b0c94fda4cc241c356be0c6a35c6fcef4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7b117c0bd8b3fbf42bb22fe35ee40db4a64d9b45cae5b13f8f15571232bdf6ce"
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