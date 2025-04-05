class LlamaCpp < Formula
  desc "LLM inference in CC++"
  homepage "https:github.comggerganovllama.cpp"
  # CMake uses Git to generate version information.
  url "https:github.comggerganovllama.cpp.git",
      tag:      "b5050",
      revision: "23106f94ea2bc3da929afb7330655fd5515d08dc"
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
    sha256 cellar: :any,                 arm64_sequoia: "c43d0f5ef4103eab2e964fd785d97e78758759eb03c4849c6f4ed3ca5318b037"
    sha256 cellar: :any,                 arm64_sonoma:  "519b1cdd72b2c2ccd7ee2b64d18a8db006f54f84489325eae9a4128451187ec0"
    sha256 cellar: :any,                 arm64_ventura: "f75562bcf8ee3c9480d27d022dba93087cdc31154a747abb713db96b27346fd9"
    sha256 cellar: :any,                 sonoma:        "b686403af0ee95bcab7db2cdd7031b919f85809fac8ad3e9687da7d2cef0738a"
    sha256 cellar: :any,                 ventura:       "1561674f6bd3bd0e5835d381accae90291637eca94383fb7c59afb42082c9362"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "422de9eb89973b3494a48fd5a3f74646aed588ae87c908f48a4d96f3892f2de0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "737cd6d2d006279b96102a2fdcb6c90371cbb5f3a55dc5465cf2be62803e1b8b"
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