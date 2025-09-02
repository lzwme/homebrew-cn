class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://github.com/ggml-org/llama.cpp"
  # CMake uses Git to generate version information.
  url "https://github.com/ggml-org/llama.cpp.git",
      tag:      "b6350",
      revision: "d4d8dbe383e8b9600cbe8b42016e3a4529b51219"
  license "MIT"
  head "https://github.com/ggml-org/llama.cpp.git", branch: "master"

  # llama.cpp publishes new tags too often
  # Having multiple updates in one day is not very convenient
  # Update formula only after 10 new tags (1 update per ≈2 days)
  #
  # `throttle 10` doesn't work
  livecheck do
    url :stable
    regex(/^v?b(\d+(?:\.\d+)*0)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "45f57496a1f707ad121a828d05d4e48b62112ac8c54951dcefedc42ef075622b"
    sha256 cellar: :any,                 arm64_sonoma:  "8c12a41486df70b8713763c6fd0898c203cc377d8866ad1801085010189124b6"
    sha256 cellar: :any,                 arm64_ventura: "62375e71c74c93f9d1a9b1eec3ced87efdd27ef5b5c081f2abdf44ddace72311"
    sha256 cellar: :any,                 sonoma:        "03fdf3b8b24be81ec6841067046c394c3f8b8d1aed2ab67b93187909f24f02d8"
    sha256 cellar: :any,                 ventura:       "44d95b1c8f5be291cda74e9bee8a60c30ee9ae6e8b70acbfcd9bb72321a30499"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3307775b4a976d4bc6e5c74d4b685fd3ffbb792a2d5d20f0d3524405f15bd568"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "78006e0e0f076112e87baa2d6cab9dc889dbe3127dd03f296a87b259b743510e"
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