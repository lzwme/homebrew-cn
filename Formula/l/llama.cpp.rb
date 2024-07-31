class LlamaCpp < Formula
  desc "LLM inference in CC++"
  homepage "https:github.comggerganovllama.cpp"
  # CMake uses Git to generate version information.
  url "https:github.comggerganovllama.cpp.git",
      tag:      "b3490",
      revision: "6e2b6000e5fe808954a7dcef8225b5b7f2c1b9e9"
  license "MIT"
  head "https:github.comggerganovllama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?b(\d+(?:\.\d+)*)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "c07c095a0a31bf6d7ddf3435ddf33335cae95e9639c4656995dbd18cdeb2ed9d"
    sha256 cellar: :any,                 arm64_ventura:  "fc4f59e7ddb25554aaf04cd0863e8aa29ff89d4361129710bf8b828142ba5ed3"
    sha256 cellar: :any,                 arm64_monterey: "0eb5b6ade8351690fa67d7a351d08e0d226207032cfd2840b85ce4ad3f783cd7"
    sha256 cellar: :any,                 sonoma:         "a497b7b2db20d60bc580162c2682bfb777d8ff0b91151c4b96320607162b6ddb"
    sha256 cellar: :any,                 ventura:        "2bf0af015d32b40611f50da18ca765c5f72eba567cbe20382392737f5a41af9f"
    sha256 cellar: :any,                 monterey:       "1789605954e948f094d6b4cdcd063d0ae5186505eefa4ee86a0b57e313a04fd1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "65d9827723c48c72d0ea2bc8cd131f27a5983f8034c8e023b400e7977a2cbce6"
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