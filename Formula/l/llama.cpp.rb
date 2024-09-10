class LlamaCpp < Formula
  desc "LLM inference in CC++"
  homepage "https:github.comggerganovllama.cpp"
  # CMake uses Git to generate version information.
  url "https:github.comggerganovllama.cpp.git",
      tag:      "b3715",
      revision: "293bebe0773c907c0c866213856eeba41b035df1"
  license "MIT"
  head "https:github.comggerganovllama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?b(\d+(?:\.\d+)*)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "875ad00f06f5a26a01bdaf92ecea21237217359f16fc018b1186fcec1348f7a8"
    sha256 cellar: :any,                 arm64_ventura:  "ce6f760b584649bada864c881f86c2481b2a5a97ee1cefc1c426a5b37456905e"
    sha256 cellar: :any,                 arm64_monterey: "bf1ce108fa8d53ca6c85f089706ef50c150413f18c371f0fbbead96238321778"
    sha256 cellar: :any,                 sonoma:         "30d80b7a337894f586989f09e5cf71a91cf70c0f6e9f0ad88e89ff7329239dd7"
    sha256 cellar: :any,                 ventura:        "a9f4b6abf7e25081482322d9ebf1eb148775b08deb485441fff0a219dafe978c"
    sha256 cellar: :any,                 monterey:       "eab73b77a41f630f2a47c86a17b88b9ccc82d6d5f7563b6221baa8f3dc0b01e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e3b39896ffe763fcf3cec8259ce49a2a84c3af9747ff4eac8c790d47a6ac2a78"
  end

  depends_on "cmake" => :build
  uses_from_macos "curl"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openblas"
  end

  def install
    args = %W[
      -DBUILD_SHARED_LIBS=ON
      -DLLAMA_LTO=ON
      -DLLAMA_CCACHE=OFF
      -DLLAMA_ALL_WARNINGS=OFF
      -DLLAMA_NATIVE=#{build.bottle? ? "OFF" : "ON"}
      -DLLAMA_ACCELLERATE=#{OS.mac? ? "ON" : "OFF"}
      -DLLAMA_BLAS=#{OS.linux? ? "ON" : "OFF"}
      -DLLAMA_BLAS_VENDOR=OpenBLAS
      -DLLAMA_METAL=#{OS.mac? ? "ON" : "OFF"}
      -DLLAMA_METAL_EMBED_LIBRARY=ON
      -DLLAMA_CURL=ON
      -DCMAKE_INSTALL_RPATH=#{rpath}
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