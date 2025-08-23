class Wasmedge < Formula
  desc "Lightweight, high-performance, and extensible WebAssembly runtime"
  homepage "https://WasmEdge.org/"
  url "https://ghfast.top/https://github.com/WasmEdge/WasmEdge/releases/download/0.15.0/WasmEdge-0.15.0-src.tar.gz"
  sha256 "17915c4d047bc7a02aca862f4852101ec8d35baab7b659593687ab8c84b00938"
  license "Apache-2.0"
  revision 1
  head "https://github.com/WasmEdge/WasmEdge.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "7a1adf8fddc71616ff4769e436fbba83303e7fbd616f87a2048af006e5609559"
    sha256 cellar: :any,                 arm64_sonoma:  "0ed9ab436f2107500dc61545740c1fb59f8d2b3d2e5dee2eabedc001cd2dde68"
    sha256 cellar: :any,                 arm64_ventura: "6bbda71c4eb30758c214028ec07ebed60bdd2bc1aa5c3c53f7d5313b76cbea4f"
    sha256 cellar: :any,                 sonoma:        "1c92c5c84fb502803bcd179d08d0c2e9a0502f7314ab3c70900168f65b7a299b"
    sha256 cellar: :any,                 ventura:       "2112ee22399008eaa276cc3b9ebd7085b9b63e4fa9b4340e2947789940fe2e9f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0de9e43ce676147d4711eee4c94a71895ba8317bcb3a1c89be47425b00977ed1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e0068658546d94d727b83bb0c9cd7cd6c67f3cd6bde0b259cc6fdaad6b71e9a6"
  end

  depends_on "cmake" => :build
  depends_on "fmt"
  depends_on "lld@20"
  depends_on "llvm@20"
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