class Wasmedge < Formula
  desc "Lightweight, high-performance, and extensible WebAssembly runtime"
  homepage "https:WasmEdge.org"
  license "Apache-2.0"
  revision 1
  head "https:github.comWasmEdgeWasmEdge.git", branch: "master"

  stable do
    url "https:github.comWasmEdgeWasmEdgereleasesdownload0.14.0WasmEdge-0.14.0-src.tar.gz"
    sha256 "3fc518c172329d128ab41671b86e3de0544bcaacdec9c9b47bfc4ce8b421dfd5"

    # fmt 11 compat
    patch do
      url "https:github.comWasmEdgeWasmEdgecommit3fda0d46a8fee41cc77eddd8a49ca3f423cf7d95.patch?full_index=1"
      sha256 "23f5555ffebed864796922376004ae5c3a95043921e2e6dae5f8fb6ac9789439"
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "7e522adfb102ab520a1e1af4d5d40bbb8c1f9e63fd4f12ca6bd73aa699aa7517"
    sha256 cellar: :any,                 arm64_sonoma:   "ae12e87e096683ebc626bb18acaf435696a9dd065d982dbed2e09a0e52339934"
    sha256 cellar: :any,                 arm64_ventura:  "5dce766cd381efbbff709ca04ff314bb495552f2ee19c7ef7d8540d349ce4b28"
    sha256 cellar: :any,                 arm64_monterey: "415cea5846fc9a53a52c9cbb97b91658a5dac871b9768a1d58282b7b09d6f1da"
    sha256 cellar: :any,                 sonoma:         "34eb565999cba9d2f50828923c54dcb6e11048b78f53a3f50b7ddc5bebad8905"
    sha256 cellar: :any,                 ventura:        "0c752b84ea5482c70b6574fff0ef04eaa4a279edf06233d9a1af6ba9fc21dc6d"
    sha256 cellar: :any,                 monterey:       "414ca41d8b8ecd0d91105c70e151ac2abb542d44fbde4fce4ab5b8c7f894ac26"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1cb31c218e277356e0435a036566961491c752886d0a11bb3dce945b2c4b3f27"
  end

  depends_on "cmake" => :build
  depends_on "fmt"
  depends_on "llvm"
  depends_on "spdlog"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    # sum.wasm was taken from wasmer.rb
    wasm = ["0061736d0100000001070160027f7f017f030201000707010373756d00000a09010700200020016a0b"].pack("H*")
    (testpath"sum.wasm").write(wasm)
    assert_equal "3\n",
      shell_output("#{bin}wasmedge --reactor #{testpath"sum.wasm"} sum 1 2")
  end
end