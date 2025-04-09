class LlamaCpp < Formula
  desc "LLM inference in CC++"
  homepage "https:github.comggerganovllama.cpp"
  # CMake uses Git to generate version information.
  url "https:github.comggerganovllama.cpp.git",
      tag:      "b5080",
      revision: "78a1ba0a4f2bfed5b8b8e312592143d22e531698"
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
    sha256 cellar: :any,                 arm64_sequoia: "10914a6ad38797ba001bfee3c47d39bf23ec28456667210434fd7c3b1d92a011"
    sha256 cellar: :any,                 arm64_sonoma:  "85702d35b32e46f16f8794d7cc3be061830fda58da3f38630509f841ea894327"
    sha256 cellar: :any,                 arm64_ventura: "e79d0240a2f0023d95983e6d48cbcf8297358ebbb8054aa8d23e13e06e6adad4"
    sha256 cellar: :any,                 sonoma:        "5ac31e514d96df19b216a3c625c9f775bb536947349c8676cae6eb7529e6d91e"
    sha256 cellar: :any,                 ventura:       "0f1e6f5878b4cdc1610ea08fae918a9328685beee22efe45cd5222d6477a2c7b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "72874a9f054734a5f8073ac6f2c381773940fe3dfcdfaa0e1f152ad3d1488b54"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d50ae1278932829f873cf727c6b94c11fcba7f66bb8c5c67f66d39aecbad98f7"
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