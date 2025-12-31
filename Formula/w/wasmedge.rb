class Wasmedge < Formula
  desc "Lightweight, high-performance, and extensible WebAssembly runtime"
  homepage "https://WasmEdge.org/"
  url "https://ghfast.top/https://github.com/WasmEdge/WasmEdge/releases/download/0.16.0/WasmEdge-0.16.0-src.tar.gz"
  sha256 "6a12152c1d7fd27e4f4fb6486c63e4c2f2663bb0c6be0edb287ef5796ed32610"
  license "Apache-2.0"
  head "https://github.com/WasmEdge/WasmEdge.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "49a11951308b058415916873c6c3d5ee0858a9027d985109ec3a74f476073fe5"
    sha256 cellar: :any,                 arm64_sequoia: "e58c96f011285612da773e514c6a7df6df60e920becc939c92974e17628cc66d"
    sha256 cellar: :any,                 arm64_sonoma:  "6fc5bc746fede293ccc8bd43a6b1a383dc29de7769d576014fa7ed0d820acb36"
    sha256 cellar: :any,                 sonoma:        "938fecbda4c144b44604865c4e9bd9bbb9f40677a962e82273444ef7d6a05e4c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c24692ad96f332b5a93cc1497daeb2b7165c5747de53533ebc87cd80742a72f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c33ed7f628ab935e02dce2f84e40ef3ca757927d4992adf8ad124e0a6f48c2a2"
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