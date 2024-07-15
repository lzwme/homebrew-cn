class LlamaCpp < Formula
  desc "LLM inference in CC++"
  homepage "https:github.comggerganovllama.cpp"
  # CMake uses Git to generate version information.
  url "https:github.comggerganovllama.cpp.git",
      tag:      "b3389",
      revision: "73cf442e7bc9baca7b3e213b261551812f1676c9"
  license "MIT"
  head "https:github.comggerganovllama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?b(\d+(?:\.\d+)*)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "8c7e775f8571099c9fead1fe47744cb4bef5a7d49cc595e5f5988c50734191e8"
    sha256 cellar: :any,                 arm64_ventura:  "9d382b1ea41a5342e1089f19631a1b7cc15977179c1558748266b98f4766c162"
    sha256 cellar: :any,                 arm64_monterey: "dcb55c2e6e0c1594fc95589be336a3f117122d3b9c446e39251e05e1b1eac012"
    sha256 cellar: :any,                 sonoma:         "89fa0e60913909fefcc19ef61efd3a2b81f02f01afcfe000d8189b3e48e105b5"
    sha256 cellar: :any,                 ventura:        "b38a97bf74625d4921c09cf157802ff2d36150feb6b1cf6d7708fc4997144a67"
    sha256 cellar: :any,                 monterey:       "a3373a74c67120eb3260029919eeba8ea95c9e3844817c89da7bb1a7523334ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a81644969d83e172f33620aad0bde7159cf16b0d220398e9f972422fdc210ae7"
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