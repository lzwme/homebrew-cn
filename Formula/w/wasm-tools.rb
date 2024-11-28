class WasmTools < Formula
  desc "Low level tooling for WebAssembly in Rust"
  homepage "https:github.combytecodealliancewasm-tools"
  url "https:github.combytecodealliancewasm-toolsarchiverefstagsv1.221.0.tar.gz"
  sha256 "98c99a2efd090dd0120a18608a41cb702ea3bf122454879166929cc6bd89ffa7"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https:github.combytecodealliancewasm-tools.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d522fce6587aecc634cdae5037bab50a1ea521fa276c96851447ddc1ceb44923"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4296c779ce33a4218dc49ea26e0a23b7294a34b147125004566cfbe95ab8ec6c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "30a6483c26e0c568826bcc824a40909527952c7bb0fdac35c5eb12109a446b8a"
    sha256 cellar: :any_skip_relocation, sonoma:        "36b9f94cc7e2f001a9f0036351c8809a682ea72d0c5b970988b0f70678669d92"
    sha256 cellar: :any_skip_relocation, ventura:       "8c2e713539d146ca4ca01a4aae35b916c74975169ccdfed808083610483f0f1e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "806ce43069a729b5ffd01be0c5540586332ae2aed35c55448aec9cd352ca86ad"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    wasm = ["0061736d0100000001070160027f7f017f030201000707010373756d00000a09010700200020016a0b"].pack("H*")
    (testpath"sum.wasm").write(wasm)
    system bin"wasm-tools", "validate", testpath"sum.wasm"

    expected = <<~EOS
      (module
        (type (;0;) (func (param i32 i32) (result i32)))
        (export "sum" (func 0))
        (func (;0;) (type 0) (param i32 i32) (result i32)
          local.get 0
          local.get 1
          i32.add
        )
      )
    EOS
    assert_equal expected, shell_output("#{bin}wasm-tools print #{testpath}sum.wasm")
  end
end