class LlamaCpp < Formula
  desc "LLM inference in CC++"
  homepage "https:github.comggerganovllama.cpp"
  # CMake uses Git to generate version information.
  url "https:github.comggerganovllama.cpp.git",
      tag:      "b3405",
      revision: "5e116e8dd51775f8f1c090570be148d5d7eea6c3"
  license "MIT"
  head "https:github.comggerganovllama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?b(\d+(?:\.\d+)*)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "7bb778906856652ce9a1b1c52a27b993b1ab01be437ed4e0d0eb9b951a689c44"
    sha256 cellar: :any,                 arm64_ventura:  "34d2ee363415d50008bcc04ec2b41a75ed4b6c5907d99cea8ce0492f1216864b"
    sha256 cellar: :any,                 arm64_monterey: "77cea70963ee2c937cafffa62e247bebef2e4619f41019cead9d1ee64cfeeebd"
    sha256 cellar: :any,                 sonoma:         "7f664bcc32af89ea71322f858a8e9e3e3f0d9b47f91b2f5e69348590ea271042"
    sha256 cellar: :any,                 ventura:        "60a84d988cda8d108cbcfccdf81566a4e719e7f23f3334d3861a9fb667b74efa"
    sha256 cellar: :any,                 monterey:       "21c2991cd8f420982161db66466aa21f7a8e03a8c1d2ca63f0072dded3940a6f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "db0d636a6a08b3107502bd8e88c1472ae776de331f7724be812d6cef800fb427"
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