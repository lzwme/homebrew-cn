class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://github.com/ggml-org/llama.cpp"
  # CMake uses Git to generate version information.
  url "https://github.com/ggml-org/llama.cpp.git",
      tag:      "b5880",
      revision: "3120413ccd7797d4cbdee32ef89a641765d1f6c4"
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
    sha256 cellar: :any,                 arm64_sequoia: "62f04ad2af045d420308d2cc6737c2d5b32ff3e47316c4cb1e2e8e94a9ec1844"
    sha256 cellar: :any,                 arm64_sonoma:  "aba439119fd61cc24efd048fb0e28bfd64cf03df4d898f9416123cc633a6d301"
    sha256 cellar: :any,                 arm64_ventura: "0b807fac7eaa8eb9673f3d6d61a434cecdabd2b6555ced6006c672d0599bf9a0"
    sha256 cellar: :any,                 sonoma:        "f4d337160039e6ff811862b6b8df2e000840dc0a08991ca8b8c51c31335a6820"
    sha256 cellar: :any,                 ventura:       "f7e20150e495e4fb7c87c491ab8d1c7d1f02d4662422efa929ad20787b1cb921"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "443bd5ea80937f3d05d79c8f86fb32ac0452e7ab408beec241059fd30e5957ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "35fc9eb244664d6764699719f0696899c1a9f24a870b8e34f68de5f3e872678d"
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
    system libexec/"test-sampling"
    # The test below is flaky on slower hardware.
    return if OS.mac? && Hardware::CPU.intel? && MacOS.version <= :monterey

    system bin/"llama-cli", "--hf-repo", "ggml-org/tiny-llamas",
                            "-m", "stories260K.gguf",
                            "-n", "400", "-p", "I", "-ngl", "0"
  end
end