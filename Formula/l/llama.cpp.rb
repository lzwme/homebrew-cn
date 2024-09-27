class LlamaCpp < Formula
  desc "LLM inference in CC++"
  homepage "https:github.comggerganovllama.cpp"
  # CMake uses Git to generate version information.
  url "https:github.comggerganovllama.cpp.git",
      tag:      "b3828",
      revision: "95bc82fbc0df6d48cf66c857a4dda3d044f45ca2"
  license "MIT"
  head "https:github.comggerganovllama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?b(\d+(?:\.\d+)*)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "bfe93a8ac5a023816a691cfdae0540cf1c1d994791fbf707b87a64209d3f8bb3"
    sha256 cellar: :any,                 arm64_sonoma:  "2b9edfc87b96f580cef11e9bda4dd9435133adbb6c89956ff6af41cddec157b6"
    sha256 cellar: :any,                 arm64_ventura: "0db0c74f364049d0e6cb141fbf3360e5a46f9da399d97b71f5686aff3901e7cc"
    sha256 cellar: :any,                 sonoma:        "9912f1dd2133ed582cc6e663bbaa09bfa2972a6e161d76feb49ed7d10dfb992f"
    sha256 cellar: :any,                 ventura:       "fa6f325c8f32ae65d7ec0ae5384c815727f35bd641e472480afc63791b681c8e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bf6c859caf19e11e510183c3f56edba7e12e6d503f3a46340d7d66748a91d6d3"
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
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DGGML_ACCELLERATE=#{OS.mac? ? "ON" : "OFF"}
      -DGGML_ALL_WARNINGS=OFF
      -DGGML_BLAS=ON
      -DGGML_BLAS_VENDOR=#{OS.mac? ? "Apple" : "OpenBLAS"}
      -DGGML_CCACHE=OFF
      -DGGML_LTO=ON
      -DGGML_METAL=#{OS.mac? ? "ON" : "OFF"}
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