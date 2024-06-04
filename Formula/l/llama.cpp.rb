class LlamaCpp < Formula
  desc "LLM inference in CC++"
  homepage "https:github.comggerganovllama.cpp"
  # CMake uses Git to generate version information.
  url "https:github.comggerganovllama.cpp.git",
      tag:      "b3078",
      revision: "bde7cd3cd949c1a85d3a199498ac98e78039d46f"
  license "MIT"
  head "https:github.comggerganovllama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?b(\d+(?:\.\d+)*)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "0f07f78dd71ecbe43e2f6080869928607e9fd7fc10f6d4901f0e2b53ed88e577"
    sha256 cellar: :any,                 arm64_ventura:  "c11e315547521802e2d990cf8ad30c87d1d681b2ac03ac13ffbe730b68d1fa02"
    sha256 cellar: :any,                 arm64_monterey: "ba423ebfdda350da3bdd5391840677b5c2189990d10955510631e756f7a0b3ea"
    sha256 cellar: :any,                 sonoma:         "43377eb5263c142920f7675d9cbf60ddd8162686d14e93bbf7af4335e892f3cb"
    sha256 cellar: :any,                 ventura:        "7d3a1ed61fe9bfdecd1fa467ce5f9a08b694cc3a176acd012d18281a7f5568fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b73408c5869be5dd44c1b3ee4695ff8d365343ba8c8a9eeadc49df181eb4c4be"
  end

  depends_on "cmake" => :build
  uses_from_macos "curl"

  on_linux do
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
    libexec.children.each do |file|
      next unless file.executable?

      new_name = if file.basename.to_s == "main"
        "llama"
      else
        "llama-#{file.basename}"
      end

      bin.install_symlink file => new_name
    end
  end

  test do
    system bin"llama", "--hf-repo", "ggml-orgtiny-llamas",
                        "-m", "stories260K.gguf",
                        "-n", "400", "-p", "I", "-ngl", "0"
  end
end