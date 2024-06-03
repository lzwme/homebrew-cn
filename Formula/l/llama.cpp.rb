class LlamaCpp < Formula
  desc "LLM inference in CC++"
  homepage "https:github.comggerganovllama.cpp"
  # CMake uses Git to generate version information.
  url "https:github.comggerganovllama.cpp.git",
      tag:      "b3067",
      revision: "9422c5e34bbd302493b77a8f6d546154a1f4fe82"
  license "MIT"
  head "https:github.comggerganovllama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?b(\d+(?:\.\d+)*)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "9302d4d2d0e7ef1e99543ab169347ba8974b905ec6b19fd0800a0909a3ec5683"
    sha256 cellar: :any,                 arm64_ventura:  "2e36aa127199d66763162c8841c6a2fda809b3c959f4d3d2ed140aa60067c479"
    sha256 cellar: :any,                 arm64_monterey: "1da1ec1c3bd918fd011ff1c833e87eb55567b94a78e1f371ef1770d27ed4aa43"
    sha256 cellar: :any,                 sonoma:         "4a866a51553c01b2fee2a923993524d29575bc78370c53c6c85574c48fe0b735"
    sha256 cellar: :any,                 ventura:        "83dfb4428bd1fe8ea44a11863d5c84fee684cb429319d6d7b1fbacf41f939bf3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c3c5c7f1f77022d44e656cd5e8cc699a8f05a387ef597b9917f86b3fc2faa90b"
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