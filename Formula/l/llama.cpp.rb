class LlamaCpp < Formula
  desc "LLM inference in CC++"
  homepage "https:github.comggerganovllama.cpp"
  # CMake uses Git to generate version information.
  url "https:github.comggerganovllama.cpp.git",
      tag:      "b5140",
      revision: "54a72720432810c89c2693f34908b60b88da1e46"
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
    sha256 cellar: :any,                 arm64_sequoia: "480b32ec85d3b85cc5cd498c8d47f2ba31afc62c46ce1d4920d50df181b02114"
    sha256 cellar: :any,                 arm64_sonoma:  "de1602aa185c91e513d49c7f402f48da474919879957320b2e3536294a30ef19"
    sha256 cellar: :any,                 arm64_ventura: "c31e27571fab99121fad28e7db1044045d71d1cfd99e3e4a20587ee67d2b2a0c"
    sha256 cellar: :any,                 sonoma:        "5243dafb463c2f33d0710918993ff30e78ce716120cd7c2c1c7777f95ee3c3e9"
    sha256 cellar: :any,                 ventura:       "e1351d200d935650ae9a2eaf02b68ceab0f387863c223061569c0b17fc906fe2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "056816f844a8061e06bbc27b6e8dc4663cd0073f87795b50b8f4ac9be116a84e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a7e2f0dc39adaaf10ff11957ba1f5fc02a03218d0657dd3c08559f9989e7f486"
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