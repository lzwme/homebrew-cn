class Wasmedge < Formula
  desc "Lightweight, high-performance, and extensible WebAssembly runtime"
  homepage "https://WasmEdge.org/"
  url "https://ghfast.top/https://github.com/WasmEdge/WasmEdge/releases/download/0.15.0/WasmEdge-0.15.0-src.tar.gz"
  sha256 "17915c4d047bc7a02aca862f4852101ec8d35baab7b659593687ab8c84b00938"
  license "Apache-2.0"
  head "https://github.com/WasmEdge/WasmEdge.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "334ae6e3e8c631ef40b45c4efd4c005ab44f5285e176e409856da764ba3dbcbf"
    sha256 cellar: :any,                 arm64_sonoma:  "a7788532fbe4de5cf3ee4ee0bfba38d70923b7b5d1aa7bd18e44a20f2efed349"
    sha256 cellar: :any,                 arm64_ventura: "d0f753e52c9a6c9d393d8981682608cf69776e0cf27d6ee7aad12235ebdbaf36"
    sha256 cellar: :any,                 sonoma:        "ab40a76cd382265bf637b0554ca50be59e27431a62017f05084a51260ab4bec5"
    sha256 cellar: :any,                 ventura:       "b41983a9b074de20f77de995c18f8b61b6d46144b2e4bbe491e92d2a1a145a01"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d834ea6796d552bd7893dafd891883d06a608af4959dc8137588a02ec648beba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "41051ce3efdd8d7736ac4e0cb9cea47caffd6e2250ee4089195d8f40236ac27d"
  end

  depends_on "cmake" => :build
  depends_on "fmt"
  depends_on "lld"
  depends_on "llvm"
  depends_on "spdlog"

  uses_from_macos "zlib"

  on_linux do
    depends_on "zstd"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
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