class LlamaCpp < Formula
  desc "LLM inference in CC++"
  homepage "https:github.comggerganovllama.cpp"
  # CMake uses Git to generate version information.
  url "https:github.comggerganovllama.cpp.git",
      tag:      "b5150",
      revision: "2db9ba1464f3de0aceb2b5289963e69fc369cb66"
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
    sha256 cellar: :any,                 arm64_sequoia: "929bb68bf3ade2d90ee997298a149834a2e1a360606a5e2576ede3a2f9c648f3"
    sha256 cellar: :any,                 arm64_sonoma:  "f0f78e9e8685e7ecbef126ee4425df30dba42d55ad06ce2ef2181d7fcdcb50f2"
    sha256 cellar: :any,                 arm64_ventura: "6071bd4736157b3f9daadeaf80649327647d4308835c343538c07d29876ea296"
    sha256 cellar: :any,                 sonoma:        "e8b28c7e6025c921a0b1fb34b9363b0406ed7792e4e1d4c21e1e4da1c50194d7"
    sha256 cellar: :any,                 ventura:       "d2cc1f96188295e1ba0abd03ee0db1fc0c86f97b7cb2aa67b14010defa9595b6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6150cf07fab8f1a4f767dfc1efbea7eace6ba0c7ec3a74e4777b3fa62fc69438"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "302cee65fd5873eb755a7b6552e2292ef1fb2fa5df365a33b0261e97ee02d8d7"
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