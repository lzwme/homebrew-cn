class Wasmedge < Formula
  desc "Lightweight, high-performance, and extensible WebAssembly runtime"
  homepage "https://WasmEdge.org/"
  license "Apache-2.0"
  revision 2
  head "https://github.com/WasmEdge/WasmEdge.git", branch: "master"

  stable do
    url "https://ghfast.top/https://github.com/WasmEdge/WasmEdge/releases/download/0.15.0/WasmEdge-0.15.0-src.tar.gz"
    sha256 "17915c4d047bc7a02aca862f4852101ec8d35baab7b659593687ab8c84b00938"

    # Backport support for LLVM 21
    patch do
      url "https://github.com/WasmEdge/WasmEdge/commit/b11791e4312445e3fd2d6c56acc9c2e36e12ef34.patch?full_index=1"
      sha256 "f9d3b39ca9871ca3d2c87f7e107651d36e9eedeccc79925879671ff552aec99b"
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "433127399a741c00d4f8e54b1d10646cb6332cf8e9eec52eb02de67d1be8207c"
    sha256 cellar: :any,                 arm64_sequoia: "a2a69c4d5ad003d3622f26d562d967d05a455df55d9ec06d2b661089c017b4be"
    sha256 cellar: :any,                 arm64_sonoma:  "37b31538a66c6e9b8b9f98ec7f8109d65433121bed55029b89d404cd8e481b5b"
    sha256 cellar: :any,                 sonoma:        "0fb1f4f7c4c4b0ce26b3a2f6f1febfea3175c63ed688967d9c5d28354a3c1219"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a324a26369bdcaa3a5208ff1f7e5657c13ce040f9d3f5f8abe1baf51a8ad41b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0a0b57c627294c3eb5085e8044c56ff1186aa60a224fc61be55dae0ff51dc32d"
  end

  depends_on "cmake" => :build
  depends_on "fmt"
  depends_on "lld"
  depends_on "llvm"
  depends_on "spdlog"

  def install
    # Use CMAKE_BUILD_WITH_INSTALL_RPATH to keep versioned LLVM in RPATH on Linux
    args = ["-DCMAKE_BUILD_WITH_INSTALL_RPATH=ON"] if OS.linux?

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    # sum.wasm was taken from wasmer.rb
    wasm = ["0061736d0100000001070160027f7f017f030201000707010373756d00000a09010700200020016a0b"].pack("H*")
    (testpath/"sum.wasm").write(wasm)
    assert_equal "3\n",
      shell_output("#{bin}/wasmedge --reactor #{testpath/"sum.wasm"} sum 1 2")
  end
end