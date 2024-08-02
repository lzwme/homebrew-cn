class LlamaCpp < Formula
  desc "LLM inference in CC++"
  homepage "https:github.comggerganovllama.cpp"
  # CMake uses Git to generate version information.
  url "https:github.comggerganovllama.cpp.git",
      tag:      "b3497",
      revision: "ed9d2854c9de4ae1f448334294e61167b04bec2a"
  license "MIT"
  head "https:github.comggerganovllama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?b(\d+(?:\.\d+)*)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "6fca1a0f163480c9898d1d23d2406360bb2e0660597b956464143086c8a0e9e4"
    sha256 cellar: :any,                 arm64_ventura:  "a0781f51ef3af0ca48e4312614a94292f9d29bd509d92ed011d41c76a29e2d37"
    sha256 cellar: :any,                 arm64_monterey: "2d2b0a5ca58d1fc12deaf0e7f8a0c43565ad53dd0a4ea440ac36a13efc0d6dda"
    sha256 cellar: :any,                 sonoma:         "3a9447b26c55321379d3d1c4b45d8b44cd6bba1f4097970f4d0605140daf4c57"
    sha256 cellar: :any,                 ventura:        "dd0b4ed799253df4c7236a677fb32a6597d2b184f80055f4b1e6b6ea609ccdb4"
    sha256 cellar: :any,                 monterey:       "0b3607316f146cb6884a6dd46c0d952f6dfdeea3fb4a9bbd1fcc1b9accd2b257"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0f5b61f9f352f8c00f80cf05d1a88192e2c854ca0a6a03dd2e70cfe265f6fa56"
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
    system bin"llama-cli", "--hf-repo", "ggml-orgtiny-llamas",
                            "-m", "stories260K.gguf",
                            "-n", "400", "-p", "I", "-ngl", "0"
  end
end