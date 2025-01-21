class LlamaCpp < Formula
  desc "LLM inference in CC++"
  homepage "https:github.comggerganovllama.cpp"
  # CMake uses Git to generate version information.
  url "https:github.comggerganovllama.cpp.git",
      tag:      "b4519",
      revision: "80d0d6b4b7abca342fc990399e78af8d213eabaf"
  license "MIT"
  head "https:github.comggerganovllama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?b(\d+(?:\.\d+)*)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "f38d86e9a6b0418b488f9afc85b88f69c5706586e7ab57d8febf46037f29e7bc"
    sha256 cellar: :any,                 arm64_sonoma:  "172ad2af3cfb1243361fe5d3343435fcdd4bbb5d3bf39522c45e935f2de93729"
    sha256 cellar: :any,                 arm64_ventura: "bd0e7dec2d5a2afe2e01f186505d4968e1d3fb0b0d4c7ac0df231829a066ce5e"
    sha256 cellar: :any,                 sonoma:        "740c036c33b484d47c971c7c8b75968bbaf4aa9644f8c51131f183ce2f654589"
    sha256 cellar: :any,                 ventura:       "8f40c930892c7bb076c0b2d599ce0099cd46a48e03ea229b0e0eb5b8bfcdfeab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "552c6445cec1c7220d99013c2a20eaafddb0a0014d1127b34e7ad667ccf1929c"
  end

  depends_on "cmake" => :build
  uses_from_macos "curl"

  on_linux do
    depends_on "pkgconf" => :build
    depends_on "openblas"
  end

  def install
    args = %W[
      -DBUILD_SHARED_LIBS=ON
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DGGML_ACCELLERATE=#{OS.mac? ? "ON" : "OFF"}
      -DGGML_ALL_WARNINGS=OFF
      -DGGML_BLAS=ON
      -DGGML_BLAS_VENDOR=#{OS.mac? ? "Apple" : "OpenBLAS"}
      -DGGML_CCACHE=OFF
      -DGGML_LTO=ON
      -DGGML_METAL=#{(OS.mac? && !Hardware::CPU.intel?) ? "ON" : "OFF"}
      -DGGML_METAL_EMBED_LIBRARY=#{OS.mac? ? "ON" : "OFF"}
      -DGGML_NATIVE=#{build.bottle? ? "OFF" : "ON"}
      -DLLAMA_ALL_WARNINGS=OFF
      -DLLAMA_CURL=ON
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
    system libexec"test-sampling"
    # The test below is flaky on slower hardware.
    return if OS.mac? && Hardware::CPU.intel? && MacOS.version <= :monterey

    system bin"llama-cli", "--hf-repo", "ggml-orgtiny-llamas",
                            "-m", "stories260K.gguf",
                            "-n", "400", "-p", "I", "-ngl", "0"
  end
end