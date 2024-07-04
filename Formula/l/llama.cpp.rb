class LlamaCpp < Formula
  desc "LLM inference in CC++"
  homepage "https:github.comggerganovllama.cpp"
  # CMake uses Git to generate version information.
  url "https:github.comggerganovllama.cpp.git",
      tag:      "b3289",
      revision: "5f2d4e60e202aabee10051e6615bb821e51787be"
  license "MIT"
  head "https:github.comggerganovllama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?b(\d+(?:\.\d+)*)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "5657af55dbf5519a675d8af87be33e3da8c190f6cad0fa5c0dfc883611ad8a62"
    sha256 cellar: :any,                 arm64_ventura:  "fcfd5dc0c41db6944aa56330da282f24975fbd246591881aad0ff0584897d449"
    sha256 cellar: :any,                 arm64_monterey: "44a74becb3484153f5567416ff563569f32250a84e81b2163146afd7fe1f8e37"
    sha256 cellar: :any,                 sonoma:         "71f122a8edf408a4c80f8fb28448201fe4c96d74b99b869259f4f234dca4f5d9"
    sha256 cellar: :any,                 ventura:        "32bb6256ab77f53b3b92ab1abdf32a77ed08247f18367d7ee8b77690280b6c68"
    sha256 cellar: :any,                 monterey:       "741818824937d64b1599474bf15b90cfb9e34f475748de3d1877eea048f63cbd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ea8a7c8b1361dfb5f1a3ba268609985dfbcda99a016583b1ca91b7aeb2d63148"
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
    system bin"llama-cli", "--hf-repo", "ggml-orgtiny-llamas",
                            "-m", "stories260K.gguf",
                            "-n", "400", "-p", "I", "-ngl", "0"
  end
end