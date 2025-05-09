class LlamaCpp < Formula
  desc "LLM inference in CC++"
  homepage "https:github.comggerganovllama.cpp"
  # CMake uses Git to generate version information.
  url "https:github.comggerganovllama.cpp.git",
      tag:      "b5310",
      revision: "70a6991edf1b60e7afa8962f830320583f3babb0"
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
    sha256 cellar: :any,                 arm64_sequoia: "7aa55b9a36d917a1f404a14b189dd66a23a0ad34060fa167654d5535cf992473"
    sha256 cellar: :any,                 arm64_sonoma:  "b71185dd3ca6a9f7819dfe94fecf591dc77813603d7145bae513e086d17ee001"
    sha256 cellar: :any,                 arm64_ventura: "58d411d0a866073243a9cbec0c09a2c3f13edd1de775631a65948c26e65646b8"
    sha256 cellar: :any,                 sonoma:        "66400e7c354932ebd925781c04256d32d6c1927546ffc9fddb060800f847be91"
    sha256 cellar: :any,                 ventura:       "65eb29d108f7ba83df13563e1e1d3dbdd407cdd54ebb072995f8884dde7bd7e0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e86717c62e9e564f3fc6f12f9238b7325a4e012053b6d1d950f0bc9b0e397f68"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5fea6fe827d863cb9e42fc55b08aa6cba1473ad2a40338d81de6c91930511711"
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