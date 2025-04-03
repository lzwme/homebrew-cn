class LlamaCpp < Formula
  desc "LLM inference in CC++"
  homepage "https:github.comggerganovllama.cpp"
  # CMake uses Git to generate version information.
  url "https:github.comggerganovllama.cpp.git",
      tag:      "b5030",
      revision: "92e3006bb69dfeb656ccf5c7c1c1efadb03c88c2"
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
    sha256 cellar: :any,                 arm64_sequoia: "0ee4c2ebddf5ebf5070df29d834a06b77b2fc7faa7fb1aa07b86161961b5220d"
    sha256 cellar: :any,                 arm64_sonoma:  "280d27e8761f42e1d1db856ea4a7bd263071cb8361186d731cca080bab7cc7ff"
    sha256 cellar: :any,                 arm64_ventura: "ea308a6936fe02afc02e323b808d5c4fca60a94fe3c9d7a31f7e72af46355a9a"
    sha256 cellar: :any,                 sonoma:        "89d6e0d9516d9531aa98cd3b21eecca88f222bdfc9f438ea0b844ed9125fdcc7"
    sha256 cellar: :any,                 ventura:       "c4f903e1394ae13e9330b8396b574498872b35064be935364abc96eb760e51b8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "58db4b0df107ac99b148a39b53f02bf54921035ab969dfed81fda1d3be1fa8e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "528d93095f92e42125494d3c385262967fba1f72bf9a5500bf4251f8d47333f3"
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