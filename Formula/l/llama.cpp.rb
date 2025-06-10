class LlamaCpp < Formula
  desc "LLM inference in CC++"
  homepage "https:github.comggerganovllama.cpp"
  # CMake uses Git to generate version information.
  url "https:github.comggerganovllama.cpp.git",
      tag:      "b5610",
      revision: "87d34b381d5868e75586210ec17b5ef5deddc276"
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
    sha256 cellar: :any,                 arm64_sequoia: "d77215d65ce18bb91a7e746edc20983dd6f001c5d16a851ca0703a82ae309ebb"
    sha256 cellar: :any,                 arm64_sonoma:  "8d7d56b082f2195636f7499f0766152901324abd8d46203db1f2a5d257a8ca42"
    sha256 cellar: :any,                 arm64_ventura: "2a35906db52f235737f26255865735854075c4000d119e993badbdf7e7846a09"
    sha256 cellar: :any,                 sonoma:        "7b671b4ba5c6b7e96c177b953e97a3bbff5f2664df0003b9155094596c937f11"
    sha256 cellar: :any,                 ventura:       "837eb7b53cde2830e46ef43e94a17631f1d8430f80a7a889150607cb5f9af7b9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "31740a322065311eb6c7bc1157a9db8494fd61158d9732919c35e9a87ac67407"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "675dc6e3690af59ecf18a6a83022489bba8cbd60693963cf04189320317fd4d6"
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