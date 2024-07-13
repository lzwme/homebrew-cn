class LlamaCpp < Formula
  desc "LLM inference in CC++"
  homepage "https:github.comggerganovllama.cpp"
  # CMake uses Git to generate version information.
  url "https:github.comggerganovllama.cpp.git",
      tag:      "b3384",
      revision: "4e24cffd8cccd653634e24ee461c252bd77b1426"
  license "MIT"
  head "https:github.comggerganovllama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?b(\d+(?:\.\d+)*)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "d0f6994ac9455062eae5055870fb787de1cd2a1bdcae83172eb1ed40af501980"
    sha256 cellar: :any,                 arm64_ventura:  "ff75830fcc8641fc9ee58ffc16ab2769e0e207f89d0b0f41e0f75de9f921ee57"
    sha256 cellar: :any,                 arm64_monterey: "2d7b2bb53c6fb591f1f79ad30d37cb6c7bca53cdd1baa6aaea1b40412313788d"
    sha256 cellar: :any,                 sonoma:         "19eb3d240ba26341234545555bf71540e7f961163a3777a2eb380fdd31f2ff77"
    sha256 cellar: :any,                 ventura:        "ce7c24ba516d5de6da2ec2a7edee628447533795d864f386dcdc357b50ede9b6"
    sha256 cellar: :any,                 monterey:       "0831a9cdc9edff787241d1c72975de752541ca48f8824b7e1a31f5e6228fe566"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "378be769e2829f1309acc894aa3dd730a16d96b068f1b6e714c8f15a8193d577"
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