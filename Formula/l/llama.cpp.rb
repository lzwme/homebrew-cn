class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://github.com/ggml-org/llama.cpp"
  # CMake uses Git to generate version information.
  url "https://github.com/ggml-org/llama.cpp.git",
      tag:      "b6070",
      revision: "15e92fd33791e60a4ddb5970b47242a855c27117"
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
    sha256 cellar: :any,                 arm64_sequoia: "26ff2e9876f7453b89f55bbe6a8edcd1231bae9352d82955dfcdf81e1f333ee3"
    sha256 cellar: :any,                 arm64_sonoma:  "3eb213ee9bea8f1a4bcc5b55111debe5f8c2288c0c9409ed0ff681f7c7769d8f"
    sha256 cellar: :any,                 arm64_ventura: "43e886056a523e829c14d4f94340045cc7d1596c291c43abd2091dafe80515b8"
    sha256 cellar: :any,                 sonoma:        "a4fe3969720b67538c3c10181b2e6062487dfa51b8ca8cd965faff9951930cc2"
    sha256 cellar: :any,                 ventura:       "10ff31b671d778c78175679464b0b6e2cd9c44474cecbd7f8b5e599f952a7a46"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bb51687645ca034e47fbe160f8a240647e9cbd36b880241699832c4d65e5ea5b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c18ca5f4183b54749f815d28a1f1960cdac9be12737267afe88c9ab4eb9de20d"
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