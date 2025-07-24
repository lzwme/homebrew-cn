class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://github.com/ggml-org/llama.cpp"
  # CMake uses Git to generate version information.
  url "https://github.com/ggml-org/llama.cpp.git",
      tag:      "b5970",
      revision: "07a19e27a26f76d34be62da53807f93131fb3cab"
  license "MIT"
  head "https://github.com/ggml-org/llama.cpp.git", branch: "master"

  # llama.cpp publishes new tags too often
  # Having multiple updates in one day is not very convenient
  # Update formula only after 10 new tags (1 update per ≈2 days)
  #
  # `trottle 10` doesn't work
  livecheck do
    url :stable
    regex(/^v?b(\d+(?:\.\d+)*0)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "4cb96bc955865aefd2a9bb312aabdc62d4b4234798e0f11aca59ac6dcf744b9d"
    sha256 cellar: :any,                 arm64_sonoma:  "00ee9ab5c096e529076413fc80def99420b015e98528453666ecc0afebbcf2c3"
    sha256 cellar: :any,                 arm64_ventura: "0dd2b774d48a35e8b58c66f50c22d9f0ab57ab41a0eb3f3d5e76b54cefa030ab"
    sha256 cellar: :any,                 sonoma:        "0b2433ff72b71c0b44d8f4961b3a0727816526dee729f39bdcaff23c63b51c86"
    sha256 cellar: :any,                 ventura:       "ef278706890d9846518fd825a94c4b9a81da0e424b2bd3db0c462d79eb0798e8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1a5868e94a1eb27bbfe293285de1bbb4943398329cbee7a0ac28dcce2d59cd5d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8e65337f1e8b62e6194fd8fa62075608f84f6d911eb4c44179b4a273ecd3974e"
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
      -DGGML_ACCELERATE=#{OS.mac? ? "ON" : "OFF"}
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
    system libexec/"test-sampling"
    # The test below is flaky on slower hardware.
    return if OS.mac? && Hardware::CPU.intel? && MacOS.version <= :monterey

    system bin/"llama-cli", "--hf-repo", "ggml-org/tiny-llamas",
                            "-m", "stories260K.gguf",
                            "-n", "400", "-p", "I", "-ngl", "0"
  end
end