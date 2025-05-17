class LlamaCpp < Formula
  desc "LLM inference in CC++"
  homepage "https:github.comggerganovllama.cpp"
  # CMake uses Git to generate version information.
  url "https:github.comggerganovllama.cpp.git",
      tag:      "b5410",
      revision: "3e0be1cacef290c99cbb99ceaa433b4344f87355"
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
    sha256 cellar: :any,                 arm64_sequoia: "6607b170186e5ae95fceae16a3f2001fa6ae348c4a98de61e1b23af2dc86be5b"
    sha256 cellar: :any,                 arm64_sonoma:  "9f3e91175f9da50ffa2f4f37e175650e88230604f0ef6d5d2bbf728235f7b0f1"
    sha256 cellar: :any,                 arm64_ventura: "77a957f2492facfaac1824281593ece6ee41d37b0155c902e3d22b1758df11b6"
    sha256 cellar: :any,                 sonoma:        "42d0cc633d87e83e9efa7b86856c42e9f5500334a66e219f9b57c03ad2dbaa4e"
    sha256 cellar: :any,                 ventura:       "b92b68b3271b1ce96cada245cc44db74a6ada3bfffc0666e8095d81e3b9d4bf6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "11058be19af12f09f7edecf2d282290fa681105205a36df11e162f58e8f7afc2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6ed2df583480ccb954b105b227d04608496c1db4d1eb7cf6ad0cfcabe3d09781"
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