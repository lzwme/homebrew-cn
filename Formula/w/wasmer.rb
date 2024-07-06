class Wasmer < Formula
  desc "Universal WebAssembly Runtime"
  homepage "https:wasmer.io"
  url "https:github.comwasmeriowasmerarchiverefstagsv4.3.3.tar.gz"
  sha256 "fbf90c01b91cf556db00c3b91b4e45ff628c8885e58ca529369885b3a93e6d13"
  license "MIT"
  head "https:github.comwasmeriowasmer.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9bc1d403ad9adb8f79129057f61662d0b7fe6929aaf9d407ce8280cf170a1738"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2e6b3182ddf4a5b4494289e4675bb16b121050bd02fe54a19812745f0159af3b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "56172fc06a75330130851ef5df7d6587ec068c16cde7298edad44e0af401204c"
    sha256 cellar: :any_skip_relocation, sonoma:         "e22b9804136de9f519ab083092666e68573d91ae8859da1fa7a723cf09d267e4"
    sha256 cellar: :any_skip_relocation, ventura:        "9d4cead4e7a0d9efaa9a5a0b0b0b4f00d922c912a6232cb8d859f396ecdd9ed3"
    sha256 cellar: :any_skip_relocation, monterey:       "80a628d9d04a4d303cf9b091c698a70efcee0be38cb9d5aea7aa486e0396b4c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e16422392fddc1c0512adfd7b0e3cd8211fd5741c69575134aa66761a2d11ddb"
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