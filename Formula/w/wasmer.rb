class Wasmer < Formula
  desc "Universal WebAssembly Runtime"
  homepage "https:wasmer.io"
  url "https:github.comwasmeriowasmerarchiverefstagsv5.0.1.tar.gz"
  sha256 "36e4efd576b6efec908b40b987a34f0a1bfe62fe94f81f717f535019ffb27e27"
  license "MIT"
  head "https:github.comwasmeriowasmer.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "634b0f2c02a919d833e68c1cfff5c63231abdd9a3af3284075a32f2da376ec44"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c73111df83a3ad6b92e31abfa9dc8085ba974723a4f29c78aa678d7a268d4cec"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8b6470b036a79fadfb4d48220e0a6e81f219936a432e57691cfad3e279aebb99"
    sha256 cellar: :any_skip_relocation, sonoma:        "cbd2a5842696b25fea1990b61a21ff820c034eb48c2db9a8930b8afa6e2d3d5e"
    sha256 cellar: :any_skip_relocation, ventura:       "864a6484962c966feaeafb37fa2680a6f75ed7018edebd04c626653417261ac1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f4d67cf74f6b6b0c67b0d515957d4912110bc2f6a9e9dff52c65ae9ab5243767"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build
  depends_on "wabt" => :build

  on_linux do
    depends_on "pkgconf" => :build
    depends_on "libxkbcommon"
  end

  def install
    system "cargo", "install", "--features", "cranelift", *std_cargo_args(path: "libcli")
  end

  test do
    wasm = ["0061736d0100000001070160027f7f017f030201000707010373756d00000a09010700200020016a0b"].pack("H*")
    (testpath"sum.wasm").write(wasm)
    assert_equal "3\n",
      shell_output("#{bin}wasmer run #{testpath"sum.wasm"} --invoke sum 1 2")
  end
end