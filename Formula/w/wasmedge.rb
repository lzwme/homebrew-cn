class Wasmedge < Formula
  desc "Lightweight, high-performance, and extensible WebAssembly runtime"
  homepage "https://WasmEdge.org/"
  url "https://ghfast.top/https://github.com/WasmEdge/WasmEdge/releases/download/0.17.2/WasmEdge-0.17.2-src.tar.gz"
  sha256 "7f2ef28b45bc136ee1f13a3453caab91d0dd2ba141dce599008486b561a63eac"
  license "Apache-2.0"
  head "https://github.com/WasmEdge/WasmEdge.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "c8dd7f640da458b28874af0e26941a04e54cb57db7860e466ec827111609a388"
    sha256 cellar: :any, arm64_tahoe:       "41cfb3d2a48f12aece589665fa2bf1228fd0934c512a44c910d9c0356c05ea65"
    sha256 cellar: :any, arm64_sequoia:     "c4b7b6e439f33a20d693d474188371f6b868f174f6ef5958f4e779f07032d4e3"
    sha256 cellar: :any, arm64_linux:       "bfb387756e7286e18ff32d9eaad245ab901d9777ffc484fb5d627124002645b6"
    sha256 cellar: :any, x86_64_linux:      "82256cea09be5b00aee7f0853506c1985f78f70436f44ee7a9916b84c4418a9b"
  end

  depends_on "cmake" => :build
  depends_on "fmt"
  depends_on "lld"
  depends_on "llvm"
  depends_on "spdlog"

  # fmt 12.2 dropped operator~ on uint128_fallback; upstream fix not in 0.17.1.
  patch do
    url "https://github.com/WasmEdge/WasmEdge/commit/41a01b6b4f40defbac0dd551663c542cdcf9ae76.patch?full_index=1"
    sha256 "55657c3a628a406b655ba224019f0121f2489140dca128c3f8c623c019de84b1"
    type :backport
    resolves "https://github.com/WasmEdge/WasmEdge/pull/4936"
  end

  deny_network_access!

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