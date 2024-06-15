class LlamaCpp < Formula
  desc "LLM inference in CC++"
  homepage "https:github.comggerganovllama.cpp"
  # CMake uses Git to generate version information.
  url "https:github.comggerganovllama.cpp.git",
      tag:      "b3151",
      revision: "f8ec8877b75774fc6c47559d529dac423877bcad"
  license "MIT"
  head "https:github.comggerganovllama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?b(\d+(?:\.\d+)*)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "a2d853b96324dff8458b6eb77c5adb3c904440da3665635dcc9033fd99e70d76"
    sha256 cellar: :any,                 arm64_ventura:  "af563ead8e1e524cece8a21217df73f81ba35c54c1f719352567132d8f3b4f5c"
    sha256 cellar: :any,                 arm64_monterey: "aa1ff3564d0f4fc8b662bb907a406d9855464be253db39ba0715f86dad1e3a16"
    sha256 cellar: :any,                 sonoma:         "e25f2eec55726b1e14c9b6827ff31a10719c8563a62cb763a42fb6b04bc8eb9d"
    sha256 cellar: :any,                 ventura:        "89399239bc09aed79712e3296040486c9bb4c4031d2e34abbd51eedef886bcce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bcff91c79bc2d91cbeefd09d9c85b766d2f85d1a9ec4d37b11163b9ef2dd0f14"
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