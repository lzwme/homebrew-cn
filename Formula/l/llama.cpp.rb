class LlamaCpp < Formula
  desc "LLM inference in CC++"
  homepage "https:github.comggerganovllama.cpp"
  # CMake uses Git to generate version information.
  url "https:github.comggerganovllama.cpp.git",
      tag:      "b5340",
      revision: "15e6125a397f6086c1dfdf7584acdb7c730313dc"
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
    sha256 cellar: :any,                 arm64_sequoia: "357559f45a8fee286719365cff5c7db67e7816584ef0e4e562a03fdfe9dba3cf"
    sha256 cellar: :any,                 arm64_sonoma:  "646f23bb911f091f0fdd03256fdd76ce4a740cc6d1969aa5b18ba8f60ac0948d"
    sha256 cellar: :any,                 arm64_ventura: "e74f06ad796c15728f008e63bf532159e44408d581a2299a277381d5a11763f1"
    sha256 cellar: :any,                 sonoma:        "97ff8f5ca8040183ad25de6f2f3617bbe82037e0dbc2730a3d6efe14b84ad1e1"
    sha256 cellar: :any,                 ventura:       "10d7e01c1284ade2351e101a0ee2949ca3e9b5084969151a2faeedf5211b2a87"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a99df8bf7051146c282c1209da3f1356da4669780859a15179b0b6f40e4e7632"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "80cd7db614f2b0f3a58a24a938651977b852949552872e747ed87cb3d8572e3d"
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