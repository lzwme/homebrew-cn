class LlamaCpp < Formula
  desc "LLM inference in CC++"
  homepage "https:github.comggerganovllama.cpp"
  # CMake uses Git to generate version information.
  url "https:github.comggerganovllama.cpp.git",
      tag:      "b3600",
      revision: "2fb9267887d24a431892ce4dccc75c7095b0d54d"
  license "MIT"
  head "https:github.comggerganovllama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?b(\d+(?:\.\d+)*)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "d38a6d0b575f0a9eb0a605976f1a8e26003e18debaa76690e4a1ed7bc20cca34"
    sha256 cellar: :any,                 arm64_ventura:  "888adecbda10f404a5cd4b32473abeab96a8ca96e7ad6ec107e15121f8fb67ac"
    sha256 cellar: :any,                 arm64_monterey: "f4d4342f14affb0a037201cc39b9aec7c22a55991c5de0ed723f34455bf3a926"
    sha256 cellar: :any,                 sonoma:         "1127ffa2a6b098961f735d3c747a6fefc75a348b96f742775441c29289e725f1"
    sha256 cellar: :any,                 ventura:        "e2e2a1b4ee2efbd5930f6d688dec80e191179b9469948b0e89dd27c8b89f1adb"
    sha256 cellar: :any,                 monterey:       "0726b6f4ddf423fe7cd6993edd67fbdbc1a721519b2fc19aee51624b0635fcf6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "124d3f20bc96b13ef1a6ba81d16117b2d34cc5b8a741bc735da218f76402d1ea"
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