class LlamaCpp < Formula
  desc "LLM inference in CC++"
  homepage "https:github.comggerganovllama.cpp"
  # CMake uses Git to generate version information.
  url "https:github.comggerganovllama.cpp.git",
      tag:      "b5480",
      revision: "4032ca406632212b075e3c61c2a4476128321410"
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
    sha256 cellar: :any,                 arm64_sequoia: "2a49011f2bb6bff7fbc3395caf8268953f5684e4a2a79320497ae179b9586bfc"
    sha256 cellar: :any,                 arm64_sonoma:  "2677d0986863bd7e94ce04b751930c7108c2de29ec070d13e663dddd1923532e"
    sha256 cellar: :any,                 arm64_ventura: "2ff63ac5503c43c9ce9f5becdcaef7253fec19ce2a8457ea01b2846bdc4d8146"
    sha256 cellar: :any,                 sonoma:        "ac19d43d38ca0bd5e347b77811d9afb2505c6171bc82cf5582f60eccd4d14f68"
    sha256 cellar: :any,                 ventura:       "11a2e465160775bd194df7668853f81cc84ef4886713133fb858474849242303"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9e18cadff90b545bd7a6cbb01498ae83e5f7cd0040886ba7b225cade06680718"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "11f97b5d503f1ce52f71af8fd8135c68be717de1881c97a1f76f7a3c2a8411c9"
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