class Wasmer < Formula
  desc "Universal WebAssembly Runtime"
  homepage "https://wasmer.io"
  url "https://ghproxy.com/https://github.com/wasmerio/wasmer/archive/refs/tags/v4.2.1.tar.gz"
  sha256 "46ee02b24b1c27e285ec54e3a828ad645b9e64e7eb1512b6aaf67185c98d4355"
  license "MIT"
  head "https://github.com/wasmerio/wasmer.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9c33551a445436bfe1af79607192fe606f613ad223536a71cf1b6d4bb0aea5ea"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "17a7ffd6e37534d0b7fe38f3b2a8edb9c029bfb63a0803e3af992e3008fdf1ab"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3ded16304a240fa05fb583ec58b1569c8f70fc70b7ec8fc06e297930f4b979f0"
    sha256 cellar: :any_skip_relocation, sonoma:         "b3b76aff6152673304bdd17e7c383f50933a39641b7e322447c9c79c86222b66"
    sha256 cellar: :any_skip_relocation, ventura:        "cf03c7fa09dc3b7683625dda56a4fecbd2a6f0711c4d93f53c1763b3d3b67d21"
    sha256 cellar: :any_skip_relocation, monterey:       "103db02a629984af7bb1c517153031c4a604995c7517553c9f3e2845fab459a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ecb255939f004476795e75b77559696ceabf684726212506324d8462a8154f33"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build
  depends_on "wabt" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "libxkbcommon"
  end

  def install
    system "cargo", "install", "--features", "cranelift", *std_cargo_args(path: "lib/cli")
  end

  test do
    wasm = ["0061736d0100000001070160027f7f017f030201000707010373756d00000a09010700200020016a0b"].pack("H*")
    (testpath/"sum.wasm").write(wasm)
    assert_equal "3\n",
      shell_output("#{bin}/wasmer run #{testpath/"sum.wasm"} --invoke sum 1 2")
  end
end