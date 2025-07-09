class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://github.com/ggml-org/llama.cpp"
  # CMake uses Git to generate version information.
  url "https://github.com/ggml-org/llama.cpp.git",
      tag:      "b5840",
      revision: "75c91de6e955d5b8f3f28173f5040593e1964eb3"
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
    sha256 cellar: :any,                 arm64_sequoia: "988373508531594a1082eb26b6ebbd1892b894b8036b98872c7872851c5d9657"
    sha256 cellar: :any,                 arm64_sonoma:  "94950afd38df871334ad785988b49e04dcdcd474bf46c3aa864a99a125728b7b"
    sha256 cellar: :any,                 arm64_ventura: "67f6574d450ea839762ecd6df35122cb25a0bccac12fccdb993d53c695272d4b"
    sha256 cellar: :any,                 sonoma:        "e3547ed6cb5870aaf5484555ffa1e3050d179fa78c7dfd941ccd76d5c9ce9366"
    sha256 cellar: :any,                 ventura:       "de900259bf1309e4243fb1943e9a19cf7cd6b0019280cf1890d880a25057da4e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "127d4d5d438189e735a8b2a92f0bfd8fd866f207adc36d35432a244beea9e7b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e56feac334de04300d805f90dba973b8af4f92c0ffab46c9c25ed654d1c226d7"
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