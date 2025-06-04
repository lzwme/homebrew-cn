class LlamaCpp < Formula
  desc "LLM inference in CC++"
  homepage "https:github.comggerganovllama.cpp"
  # CMake uses Git to generate version information.
  url "https:github.comggerganovllama.cpp.git",
      tag:      "b5580",
      revision: "bfb1e012a0b7658e8f00ed4333d059943ea9d648"
  license "MIT"
  head "https:github.comggerganovllama.cpp.git", branch: "master"

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
    sha256 cellar: :any,                 arm64_sequoia: "a384fca36df0a1306083a20d7d4b577b39b83b9dfa72e1c6d54b799e18195a82"
    sha256 cellar: :any,                 arm64_sonoma:  "c050fc66ac8bcadffee112f10b2e7c88fd7f50a936dba599420478cad5a48957"
    sha256 cellar: :any,                 arm64_ventura: "10e7a4d2a6eb7593b0fac422a7b22e1515d6edf28946a45c2f0c6f4b9c964c97"
    sha256 cellar: :any,                 sonoma:        "d9086bda3257c2565e5caebf7d5e3da85600257cb2572c2044f8929d4da548d1"
    sha256 cellar: :any,                 ventura:       "fda628e7010e1fa570d6e38a4c565dd79696616821764210618d7544a13cf15d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f765a34d65873e22c8a026d440f2f9f9da5823b8dfa3e0635e8300a84c005a25"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eb3d453bff228b52945512cc90b2d1a2407695270bc0a0cd3ebc25e4d4376bc0"
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