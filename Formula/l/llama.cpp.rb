class LlamaCpp < Formula
  desc "LLM inference in CC++"
  homepage "https:github.comggerganovllama.cpp"
  # CMake uses Git to generate version information.
  url "https:github.comggerganovllama.cpp.git",
      tag:      "b5460",
      revision: "3079e9ac8e04ef6eddeb0c164d72edb6b6fd2df5"
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
    sha256 cellar: :any,                 arm64_sequoia: "1552c9078bb467d3b6a6b516ea053a5903ba6ab585cdfb9741c31fc6cf6001fd"
    sha256 cellar: :any,                 arm64_sonoma:  "8f0b5019e4fc35fd0d38ae5426cc1861ec63fe1f39e5b7682e19b580a35b5e64"
    sha256 cellar: :any,                 arm64_ventura: "632b528f53439419f479d3506329bf547afc76f55a968d34a2bec6d5613acd75"
    sha256 cellar: :any,                 sonoma:        "498464295db3666f70b83d5d575eee28d2586eb88549b432cf8d7be4e2de3065"
    sha256 cellar: :any,                 ventura:       "1427fd14bfae960d3bd3d220967f7de3784da67c487f4525237810051c43371a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "05c775dbcfefceefe29f6c327d926b725a73539e976f8bcda2d7516830a607f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "61d6fbd8fa779035307a75f4895b1cd61ca666a3303d15faf6eb955c2dd162c9"
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