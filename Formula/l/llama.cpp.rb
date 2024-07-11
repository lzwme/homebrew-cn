class LlamaCpp < Formula
  desc "LLM inference in CC++"
  homepage "https:github.comggerganovllama.cpp"
  # CMake uses Git to generate version information.
  url "https:github.comggerganovllama.cpp.git",
      tag:      "b3368",
      revision: "dd07a123b79f9bd9e8a4ba0447427b3083e9347a"
  license "MIT"
  head "https:github.comggerganovllama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?b(\d+(?:\.\d+)*)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "9949becb8127bbdbccae33d9e523deca06a83575ed6bfbd4c359f03af68ce287"
    sha256 cellar: :any,                 arm64_ventura:  "e3ae31c796ddd76f2f4f14dc3ff8861dd9afb9eeacda076eb657b8a359b3337a"
    sha256 cellar: :any,                 arm64_monterey: "e208ec441b8975ca2838cd4c412495e835426281c2286811ae2108073a31b9f4"
    sha256 cellar: :any,                 sonoma:         "598e9b921d031f486ba6af0b0c0f6026c8a1691d3d7f943e473f869205ccc065"
    sha256 cellar: :any,                 ventura:        "31bd09d341106be20ebc4a404c8033fc01d3389ac1355fd0be3439b99f02529c"
    sha256 cellar: :any,                 monterey:       "5ab3d7350e8aad6d2a3aaecbc81b2ad784c5d66bf9bf68cb27a081bd9616b22b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "410b3c36ec8d570bcd1867b0296522408f71b6239dac7d08def04b062a845dbb"
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