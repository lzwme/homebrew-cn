class LlamaCpp < Formula
  desc "LLM inference in CC++"
  homepage "https:github.comggerganovllama.cpp"
  # CMake uses Git to generate version information.
  url "https:github.comggerganovllama.cpp.git",
      tag:      "b3584",
      revision: "5fd89a70ead34d1a17015ddecad05aaa2490ca46"
  license "MIT"
  head "https:github.comggerganovllama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?b(\d+(?:\.\d+)*)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "d4175f77507755ba6f94db89a3f2b9055e9e082338649cc3eca4ba9f564fb24b"
    sha256 cellar: :any,                 arm64_ventura:  "fb552cb58143b0cba48251da4a04011fb16e0cf2518a7c34005b0fc1d57df17c"
    sha256 cellar: :any,                 arm64_monterey: "141946e4a07b4093ad5cbe000eb0e7855888aa1869d29205d1f858d736314a81"
    sha256 cellar: :any,                 sonoma:         "3fc846e919177565137ac9c7733cf1ca025fc47aaf3ae196ac304b2868e18fa3"
    sha256 cellar: :any,                 ventura:        "7fe1a66878ee9257a6bba47dc384c101ccc9f04ee5a4f0d6a80b209e57603409"
    sha256 cellar: :any,                 monterey:       "c7ad4ed9a9d1b6580b74ccbf75011b4485a79fe060d0d4cbd0a2c842460816f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1d9e1d642c58fb2901557a67da1fe85f5843e40902f1c102efde93cb8c506530"
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