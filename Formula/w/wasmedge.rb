class Wasmedge < Formula
  desc "Lightweight, high-performance, and extensible WebAssembly runtime"
  homepage "https://WasmEdge.org/"
  url "https://ghfast.top/https://github.com/WasmEdge/WasmEdge/releases/download/0.16.0/WasmEdge-0.16.0-src.tar.gz"
  sha256 "6a12152c1d7fd27e4f4fb6486c63e4c2f2663bb0c6be0edb287ef5796ed32610"
  license "Apache-2.0"
  revision 1
  head "https://github.com/WasmEdge/WasmEdge.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "795c3d010d96d15af80ecfc7e5f2d30e6aec3db4de88b5c47bf404c28d6726b7"
    sha256 cellar: :any,                 arm64_sequoia: "d6de57d459b125caf80f6d81add83df6bb1b490ffc273b69eea6f4eff1ce20b6"
    sha256 cellar: :any,                 arm64_sonoma:  "42fb88c08046bd7f7c730d86b5a732d6bd8072430e55f22d80fdffa6da7bc4c6"
    sha256 cellar: :any,                 sonoma:        "ab850da1a998976a418fa60e2c44d738390fb4746c6243e215c427ecf0bc10d8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "200f391a76b1a3c6d096e864f8d27c39aa318a671185f1c5f959791b0a01f3c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a5dfaf2ca3e72990cd712dafebfec607717bb5fb932f8fc6640d5a3c0985355f"
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