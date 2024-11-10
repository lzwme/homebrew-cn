class LlamaCpp < Formula
  desc "LLM inference in CC++"
  homepage "https:github.comggerganovllama.cpp"
  # CMake uses Git to generate version information.
  url "https:github.comggerganovllama.cpp.git",
      tag:      "b4061",
      revision: "6423c65aa8be1b98f990cf207422505ac5a441a1"
  license "MIT"
  head "https:github.comggerganovllama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?b(\d+(?:\.\d+)*)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "57afd8587b7d74700071c992dff2aae40e9a2d6a9f439ecd7f0f76af5457f687"
    sha256 cellar: :any,                 arm64_sonoma:  "4c8cc36edf0117dc2c72c4f0934f730ccbb3be1847241132eb7957c3534f03f8"
    sha256 cellar: :any,                 arm64_ventura: "30a7ed4ee0c4d049ef17411aded2a64a05c6d857e64fd547f6b704e920862cb0"
    sha256 cellar: :any,                 sonoma:        "caf8e1cfc2bf7ceb640eef7ec519fef333d1100fcc554b4a0eef3cd0bdb7c0f2"
    sha256 cellar: :any,                 ventura:       "c7ebc8bd600ffcbce840ab66505fb3f5ffd31f1b4eebcb6f86159dbb7902383c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4ad55d8f3db036451732de493abf8e0ed70d5a666d89582e4f68c3d5b2c428bd"
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