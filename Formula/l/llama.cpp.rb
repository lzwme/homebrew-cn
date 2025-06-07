class LlamaCpp < Formula
  desc "LLM inference in CC++"
  homepage "https:github.comggerganovllama.cpp"
  # CMake uses Git to generate version information.
  url "https:github.comggerganovllama.cpp.git",
      tag:      "b5600",
      revision: "d17a809ef0af09b16625e991a76f6fe80d9c332e"
  license "MIT"
  head "https:github.comggerganovllama.cpp.git", branch: "master"

  # llama.cpp publishes new tags too often
  # Having multiple updates in one day is not very convenient
  # Update formula only after 10 new tags (1 update per ≈2 days)
  #
  # `trottle 10` doesn't work
  livecheck do
    url :stable
    regex(^v?b(\d+(?:\.\d+)*0)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "d877394a38055eda24b6bdf1c1940bb3508dcc423e1a4ac77e58e684a571e5a5"
    sha256 cellar: :any,                 arm64_sonoma:  "939858a66b7e9f28cbd2ea620b3d0f847711a02ab1384ca527a996aba9fc61b4"
    sha256 cellar: :any,                 arm64_ventura: "9a856c4c9fc87f6693daeeeaa629b2e475fcdafd7f9bd11c4c21c89bc3375c04"
    sha256 cellar: :any,                 sonoma:        "6ff2deac4ba97a643764cac5c39be4b5cf1e811738fd8d74366a5412b2007460"
    sha256 cellar: :any,                 ventura:       "76d2657f8880e1cac509037670c11d1051d82bdb66d8b9e7b230e2a7a329b773"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a4cd5e771b0702cb0ac82d19d7136953d87afe5ed5496017e8b7a640992e9121"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "be3358be90db5007e0e5a6e488f0856ccaa3864f22dd559cde4c3d1ba5fa6733"
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
    system libexec"test-sampling"
    # The test below is flaky on slower hardware.
    return if OS.mac? && Hardware::CPU.intel? && MacOS.version <= :monterey

    system bin"llama-cli", "--hf-repo", "ggml-orgtiny-llamas",
                            "-m", "stories260K.gguf",
                            "-n", "400", "-p", "I", "-ngl", "0"
  end
end