class LlamaCpp < Formula
  desc "LLM inference in CC++"
  homepage "https:github.comggml-orgllama.cpp"
  # CMake uses Git to generate version information.
  url "https:github.comggml-orgllama.cpp.git",
      tag:      "b5740",
      revision: "fa4a9f2a1ccda2573189a9d4995bdf0bceb41156"
  license "MIT"
  head "https:github.comggml-orgllama.cpp.git", branch: "master"

  # llama.cpp publishes new tags too often
  # Having multiple updates in one day is not very convenient
  # Update formula only after 10 new tags (1 update per ≈2 days)
  #
  # `trottle 10` doesn't work
  livecheck do
    url :stable
    regex(^v?b(\d+(?:\.\d+)*0)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "80751fce5ed9229e7da24f55b04d6d3af8517aa30ee08e0c296e2f54d19b1727"
    sha256 cellar: :any,                 arm64_sonoma:  "0c29a01532a35bf605a42e0ca9415b5c1a2f8ddcc74c4eab5834905361db6072"
    sha256 cellar: :any,                 arm64_ventura: "e5fbc88f0410f90099ee64c1253238f75da28a3e9b3b942db83857dbc71c8be0"
    sha256 cellar: :any,                 sonoma:        "1c4493c415a524f4c444ca6fe435045bc7e3c9541cd793827f3d7ed758591938"
    sha256 cellar: :any,                 ventura:       "967caf459d1ec6860ea04d7da17801837e8dfd9bf4a87acb7edbb569359e4fb0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "daa7724e7d728d7768c84e71f6f869c7724dd08632ac8da934c6b6607641d461"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a1c5ab0d4fdbe39bd381406fc604489e40843fac0f791fcf29473501cebaabef"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  uses_from_macos "curl"

  on_linux do
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