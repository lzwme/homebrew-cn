class Wasmer < Formula
  desc "Universal WebAssembly Runtime"
  homepage "https:wasmer.io"
  url "https:github.comwasmeriowasmerarchiverefstagsv4.3.4.tar.gz"
  sha256 "0e18c0aedec7f62d1397091501332af1e0b164c75f25a44743db96a52c5ee688"
  license "MIT"
  head "https:github.comwasmeriowasmer.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "eb0f645abcb3963f70a40cd0ebe0d8bafc9861b57ae319e66cf346154da60a30"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "690a5bcb3604ba8dc00a9e29fcb641cf44893a60987ee50ed211420245a21a1b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "57d3df835596f9d92f77a99a2b81d70bf5ca7dffb184c7df588c8803dbdce0df"
    sha256 cellar: :any_skip_relocation, sonoma:         "8311dd3abc2decfe214ba42eba7746e6159c6b6e06ee6b1cfe84d84bb883a027"
    sha256 cellar: :any_skip_relocation, ventura:        "1ae24301945f631af23bb782d72947fcdef90b31ccde0e3ba2e22450a64616f6"
    sha256 cellar: :any_skip_relocation, monterey:       "8add80f2e4563abb4a9e864c97e24529a3c361aa73fbddad7ab7cf26fd3cb31e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fdcdece5024b77cf621973778b0b761e77548ce684e288a11030f95b941ed3f5"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build
  depends_on "wabt" => :build

  on_linux do
    depends_on "pkg-config" => :build
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