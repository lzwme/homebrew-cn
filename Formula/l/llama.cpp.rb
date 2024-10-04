class LlamaCpp < Formula
  desc "LLM inference in CC++"
  homepage "https:github.comggerganovllama.cpp"
  # CMake uses Git to generate version information.
  url "https:github.comggerganovllama.cpp.git",
      tag:      "b3878",
      revision: "d5ed2b929d85bbd7dbeecb690880f07d9d7a6077"
  license "MIT"
  head "https:github.comggerganovllama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?b(\d+(?:\.\d+)*)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "3b00b315c4ee9ba7ba9a443d9fce93d48f1c60fbad3692a729054961930fcdbc"
    sha256 cellar: :any,                 arm64_sonoma:  "9e901f1727542ca590ee29248646deaa239f35811ef7ab33b227ab990fb88400"
    sha256 cellar: :any,                 arm64_ventura: "c6eeabc617cc53ddcd641e972df2170c7d04b78c242886c54d3b63b32564e4b4"
    sha256 cellar: :any,                 sonoma:        "f5550ef6036755679ffd9ec86885ef7567aaacfc7e5c8a4c6ad7ee8427975b97"
    sha256 cellar: :any,                 ventura:       "aa42effb3c52a0f666ae2ebbe9de95bcc2430898f1dc344b892830dd54e31ae1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "089ed0102f0aa40047083c9ccc5ef535e3e08f1b91e69783eec452e8fc0e51b7"
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
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DGGML_ACCELLERATE=#{OS.mac? ? "ON" : "OFF"}
      -DGGML_ALL_WARNINGS=OFF
      -DGGML_BLAS=ON
      -DGGML_BLAS_VENDOR=#{OS.mac? ? "Apple" : "OpenBLAS"}
      -DGGML_CCACHE=OFF
      -DGGML_LTO=ON
      -DGGML_METAL=#{OS.mac? ? "ON" : "OFF"}
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