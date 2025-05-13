class LlamaCpp < Formula
  desc "LLM inference in CC++"
  homepage "https:github.comggerganovllama.cpp"
  # CMake uses Git to generate version information.
  url "https:github.comggerganovllama.cpp.git",
      tag:      "b5360",
      revision: "f0d46ef15717cd609a7b69cf6190edde64d466c8"
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
    sha256 cellar: :any,                 arm64_sequoia: "2ef25afa747ce9ccb830d004a79bc0f32947eb76e69255109d3d11c406913950"
    sha256 cellar: :any,                 arm64_sonoma:  "3af8608bec24f596fd99c8be784533841a7a9af7eab5133a2f081a02932ffbb1"
    sha256 cellar: :any,                 arm64_ventura: "6959e18fb39e1b2f59465fe52c79118e19b2d0a38dfaaed9c4d9ba10e72d9928"
    sha256 cellar: :any,                 sonoma:        "e9bac43647cd1f5cb38c8d784bda5c5d7ca0901dd878e4ea8790a040849cb34a"
    sha256 cellar: :any,                 ventura:       "711f58ac70305aa70e8b4d808c306fae05c2f9a710d0ddc1164278855a672e49"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a3015000e640887956a35d23b88e138163b3f1bae5a6d387847a9ed1da9ad368"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a5129fbd214441ea1c8137ac082a25a5446169e9c78182a309a49f4231f46cde"
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