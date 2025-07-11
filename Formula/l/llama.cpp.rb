class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://github.com/ggml-org/llama.cpp"
  # CMake uses Git to generate version information.
  url "https://github.com/ggml-org/llama.cpp.git",
      tag:      "b5860",
      revision: "f9a867f5921a85f3fa64d7b067f4c8ffc5f62eb4"
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
    sha256 cellar: :any,                 arm64_sequoia: "77ccdb222551fe7acc3f47bc1864693b1199eec5cb681c572d77ba1ffff43315"
    sha256 cellar: :any,                 arm64_sonoma:  "0b4a6ffad859e42ffb1089a0d952c442229a08246c158c7e55bbcd75f3d6fb9c"
    sha256 cellar: :any,                 arm64_ventura: "234cb61d7c6a48b190d33387064f0064cf12ab86d0f74eed44b6e00114f5c6bc"
    sha256 cellar: :any,                 sonoma:        "8e587d64e28c7e059a13099c798fda73d2cd5d9b54c328c3950dd9beb762a988"
    sha256 cellar: :any,                 ventura:       "da8cf0de7ff9d1bfc216c60faa5f7e8b6ab42f0535e22ad15a0c2b67b4638ad2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "902b96f55d4c1787d0f1e3cb4e82a8a7eb66bc8b6d3dbca7a106eceadc27a52a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4fb09e31ffde0dd4ee8b961eaa04154d259948b5750f8ef3a5f03fc316617b51"
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