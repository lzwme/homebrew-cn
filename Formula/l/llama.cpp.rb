class LlamaCpp < Formula
  desc "LLM inference in CC++"
  homepage "https:github.comggerganovllama.cpp"
  # CMake uses Git to generate version information.
  url "https:github.comggerganovllama.cpp.git",
      tag:      "b5170",
      revision: "658987cfc9d752dca7758987390d5fb1a7a0a54a"
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
    sha256 cellar: :any,                 arm64_sequoia: "3eed6e83e23a6d2775b30828d5964192652e9de8bc0ff770be816b931b28ce13"
    sha256 cellar: :any,                 arm64_sonoma:  "d44474c936351a6a8c794a029653534e7ecf5d1db0a2b010fac062dae7403df8"
    sha256 cellar: :any,                 arm64_ventura: "29aa3b10c59cb36dae13a4913c3817d49a554afd86ae3615d7ca2281815b14c7"
    sha256 cellar: :any,                 sonoma:        "6143cb16aedf3d754d9f5ebd08bfc90d19b2d055396119a1f201278e3e783afe"
    sha256 cellar: :any,                 ventura:       "29353378b17071fc860995d012ea9e7caad299c64e1a5f141c057c7b5d958c6d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "12036c0d9a882c4c368e99a38f94f5cd41772cbe5817bfdd31cbe511b3eb924c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3386538b14abf7df75966240a09999d1cba5018bce57b76e1b92ac707b020e9b"
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