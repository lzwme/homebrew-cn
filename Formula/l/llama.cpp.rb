class LlamaCpp < Formula
  desc "LLM inference in CC++"
  homepage "https:github.comggerganovllama.cpp"
  # CMake uses Git to generate version information.
  url "https:github.comggerganovllama.cpp.git",
      tag:      "b3676",
      revision: "815b1fb20a53e439882171757825bacb1350de04"
  license "MIT"
  head "https:github.comggerganovllama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?b(\d+(?:\.\d+)*)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "b2f7b09fa4ee5ac7000db06dd14e2234a529ec1bcb33b925cf5d5decda751761"
    sha256 cellar: :any,                 arm64_ventura:  "026208621d67bbb5748a6f5f12c2c660a5e581881252d332c4350cb69b4f1e60"
    sha256 cellar: :any,                 arm64_monterey: "ba14f5a5f19a2cc0de89d5af981acea0ba9692b972b19e32875d3bce63f309ca"
    sha256 cellar: :any,                 sonoma:         "07735a0b0db3ca0677e60178d787945f09592d65479dd7a7cd33a82c1789a9c6"
    sha256 cellar: :any,                 ventura:        "f482df3765921ac4042f2b57cf60215a38539acbbf36c0d0e7c09cb2fdf20fa2"
    sha256 cellar: :any,                 monterey:       "1804968ca1d1beac08b515ae4f742554cb6e62e9f37b5921f204a0cca5eff247"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6dfd1e668a985d869008c68ebca5096e8260d3e604b9346ed4e13c112d755e21"
  end

  depends_on "cmake" => :build
  uses_from_macos "curl"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openblas"
  end

  def install
    args = %W[
      -DBUILD_SHARED_LIBS=ON
      -DLLAMA_LTO=ON
      -DLLAMA_CCACHE=OFF
      -DLLAMA_ALL_WARNINGS=OFF
      -DLLAMA_NATIVE=#{build.bottle? ? "OFF" : "ON"}
      -DLLAMA_ACCELLERATE=#{OS.mac? ? "ON" : "OFF"}
      -DLLAMA_BLAS=#{OS.linux? ? "ON" : "OFF"}
      -DLLAMA_BLAS_VENDOR=OpenBLAS
      -DLLAMA_METAL=#{OS.mac? ? "ON" : "OFF"}
      -DLLAMA_METAL_EMBED_LIBRARY=ON
      -DLLAMA_CURL=ON
      -DCMAKE_INSTALL_RPATH=#{rpath}
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