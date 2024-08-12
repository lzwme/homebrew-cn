class LlamaCpp < Formula
  desc "LLM inference in CC++"
  homepage "https:github.comggerganovllama.cpp"
  # CMake uses Git to generate version information.
  url "https:github.comggerganovllama.cpp.git",
      tag:      "b3567",
      revision: "33309f661a93c9c0ab65a79e5e7e30fa6162992e"
  license "MIT"
  head "https:github.comggerganovllama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?b(\d+(?:\.\d+)*)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "607c1b8a4d79891b5c8e33b78303ea92f783d911dfd72c5bed99c6f11310cab8"
    sha256 cellar: :any,                 arm64_ventura:  "389f78897a555e6f395e3e9ffa0e430267fe5790060b44cf7228a78e5196c239"
    sha256 cellar: :any,                 arm64_monterey: "2b565a510dc56e7644fc90c67d2d07c7b42c9e37a32bb5d5ea8de18380419bf6"
    sha256 cellar: :any,                 sonoma:         "7dc413798311d3c1cf33f21fee8b1478a718fc74ede735b84a286e33e3dcd685"
    sha256 cellar: :any,                 ventura:        "8e6b3ceb86906d27746d92707529e16890925aaf9b8c1067cb4ce692cd14a81b"
    sha256 cellar: :any,                 monterey:       "4f437ab24cf0ec7296e98eb2161ebf6c1088c88941cf7da63b12bfcb745dc10c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "89c447b67e0c6aee1b1a80539ad94585bff6133b7ef24ba0c2bf1bbab46a192e"
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