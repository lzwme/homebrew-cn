class LlamaCpp < Formula
  desc "LLM inference in CC++"
  homepage "https:github.comggerganovllama.cpp"
  # CMake uses Git to generate version information.
  url "https:github.comggerganovllama.cpp.git",
      tag:      "b3565",
      revision: "6e02327e8b7837358e0406bf90a4632e18e27846"
  license "MIT"
  head "https:github.comggerganovllama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?b(\d+(?:\.\d+)*)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "20f28d657621d076f676fc0070616825c69401b3f3a301bf1bf6303163fd9f9a"
    sha256 cellar: :any,                 arm64_ventura:  "25bdee0f3b67a1b653bc745bc09412c987c2f4d3a33417b6038ba9e4ee61b67a"
    sha256 cellar: :any,                 arm64_monterey: "27717810b4397c044da4d2307995d88c8c2c853dd262a821a9bd5929dd063ba0"
    sha256 cellar: :any,                 sonoma:         "2f2010cf029218a956f2319cf4f2b26beda095e898cc6279fc2551e244eae887"
    sha256 cellar: :any,                 ventura:        "c4a7135092eba5ec1c0571ec2c1ca80dedb413f37efd3106da707d3f8d3aa612"
    sha256 cellar: :any,                 monterey:       "03a62a1c2804ed779fd133adddef05c0610bf74842a1e93a81803a6063fcc4e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "335231e0b0d5e146cd25929f37db5ba476ac43c37dc8d5564032a323bd917f5b"
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