class LlamaCpp < Formula
  desc "LLM inference in CC++"
  homepage "https:github.comggerganovllama.cpp"
  # CMake uses Git to generate version information.
  url "https:github.comggerganovllama.cpp.git",
      tag:      "b3599",
      revision: "8b3befc0e2ed8fb18b903735831496b8b0c80949"
  license "MIT"
  head "https:github.comggerganovllama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?b(\d+(?:\.\d+)*)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "a2581a26cf0cfd632b68203e0040f607af18c0b344f417a6cfb0cd3e6af8f4ed"
    sha256 cellar: :any,                 arm64_ventura:  "f88ee6a640a5ad6e9883c780b2c0f67ee6db62134856f5a2eaa23e0e9766e62b"
    sha256 cellar: :any,                 arm64_monterey: "2edeb55fba684a06edc555002afb107a10977190424b5b967e65258cebe5b462"
    sha256 cellar: :any,                 sonoma:         "a7b9ba21ff979cef5132cf5858108a43448eaf3b2907410602fdb65865d31da6"
    sha256 cellar: :any,                 ventura:        "8cb4dfbc1dcbbfa3fee7ef633d4dd12068295fdf6666cbfb2e2c72704f60b954"
    sha256 cellar: :any,                 monterey:       "b9c6cf4d3517690ee98920702e4c62f893fc7cc0de067f98fa103dfbcb6b959c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5a3beda9924f23b62c7a2ed9897b974f7d64ed542dfa6c98711910af2c788796"
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