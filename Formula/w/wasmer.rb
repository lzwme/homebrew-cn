class Wasmer < Formula
  desc "Universal WebAssembly Runtime"
  homepage "https:wasmer.io"
  url "https:github.comwasmeriowasmerarchiverefstagsv4.3.7.tar.gz"
  sha256 "9bbbac3845888ee709c8b160fdefb0fe808f2cff23033464629e39a69f4694f8"
  license "MIT"
  head "https:github.comwasmeriowasmer.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "150135be11a6868267e2aba4a7cee1ae30575b02e92a8ad9289a6758e8f04bc6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7fe192397c7475f97c7bf42a2c1e50c160b7f57f37135e8f448c13d37146e1d0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "20bd629b921f92509ff52718460a9307a13c51dc37cc0afb6da737d074fb79de"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ebbbd581ba28a38173860adb4bc6db451675a8b64f482a0fa2d2aebc9a9fb820"
    sha256 cellar: :any_skip_relocation, sonoma:         "81e1fa195609f1289f9926520c916a1553c57cb133b4cf61d9b0b45f59995227"
    sha256 cellar: :any_skip_relocation, ventura:        "48e711d48061f23e8fd1ac524ae1c4e98dec610a6ce84b22169609fc550f0933"
    sha256 cellar: :any_skip_relocation, monterey:       "e44eacebde63e25a767a428a517fd1f320df6fddd51cb185ac26d933e12b51fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c32a9016da3221aced8377faf186d1cb31dbdf7c2aeecc2aef56e97cfb26ca0b"
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