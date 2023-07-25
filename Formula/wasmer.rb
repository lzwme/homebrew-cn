class Wasmer < Formula
  desc "Universal WebAssembly Runtime"
  homepage "https://wasmer.io"
  url "https://ghproxy.com/https://github.com/wasmerio/wasmer/archive/refs/tags/v4.1.0.tar.gz"
  sha256 "ade50526c799a0ff3e58e40bb63dd74a310d0b05035c9ce6923b979fb16eb3d7"
  license "MIT"
  head "https://github.com/wasmerio/wasmer.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "902e02fc7efdcc240792d2bfc51fe66517524a805c77a929ca1a7b10d847c8c4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bef4dbeb3bbff126dec156380f571b8284c31879b7f17113bc52d017533d851a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "96bb382e0755fbf4e117f9f47a1691618508ea5d15faaffc4960c09f57ad60db"
    sha256 cellar: :any_skip_relocation, ventura:        "e9ccac3d6038b5335fcf516f9220c44f2546bc160a00222b27fe3d528ea3bd2a"
    sha256 cellar: :any_skip_relocation, monterey:       "4b161edf0fd7857e5e03d9019ff3953dca2ed15a6c77b503ba961fcb67019e02"
    sha256 cellar: :any_skip_relocation, big_sur:        "4358a6acdd3330cee4a5c3b820f9e2675853e1614c2ca798af64aef10262fc33"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d24428238844f27db1d92fcead7006299c78ea5b5b71df5fbdf461af4f810efe"
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