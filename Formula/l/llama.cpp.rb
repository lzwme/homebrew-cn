class LlamaCpp < Formula
  desc "LLM inference in CC++"
  homepage "https:github.comggerganovllama.cpp"
  # CMake uses Git to generate version information.
  url "https:github.comggerganovllama.cpp.git",
      tag:      "b5400",
      revision: "c6a2c9e7411f54b0770b319740561bbd6a2ebd27"
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
    sha256 cellar: :any,                 arm64_sequoia: "929141688c8b9ec50a9b525ecf35c550f92bb917b12614a4c5cd1d2004fd2aef"
    sha256 cellar: :any,                 arm64_sonoma:  "8a24eff28a2b42e05f1bd2a82c663fe4a95b6ec2be9cc8bfbffb71157da45a50"
    sha256 cellar: :any,                 arm64_ventura: "411984af41ff068e7f0b720717ee7798a91a1ce65345b19dedeedfa1d3efa27e"
    sha256 cellar: :any,                 sonoma:        "0525a49ea5d6b3c554e6e94453ba82c6862e43bd86a4b00b61b8dc819ecf8ff2"
    sha256 cellar: :any,                 ventura:       "4dc6349a43dbd9fab290740df7dc2e45db35ac6f434451637ea242cf9a94900e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f6c060f4d8fab7be7f346573de2376bac9f4bb80546eb8a1433d1fe63fb23412"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cfa016f9677c997baa195d081ee2b853955cfefd02755f7fdcd949ec49345d63"
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