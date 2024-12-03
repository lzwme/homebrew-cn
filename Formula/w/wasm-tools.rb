class WasmTools < Formula
  desc "Low level tooling for WebAssembly in Rust"
  homepage "https:github.combytecodealliancewasm-tools"
  url "https:github.combytecodealliancewasm-toolsarchiverefstagsv1.221.2.tar.gz"
  sha256 "9940c19aa878f500a031282f13401fb6177517a238220246bbcea0d642ee8934"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https:github.combytecodealliancewasm-tools.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2343a823317f787228ec38da622e80f9bfb8db9d1b9d9679050bdef9da043545"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2400b3f7a18541b50c8e17894fd1764069bb35da76191652abaa67667e80d5e3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6ea066320d39bf92178bff009d7736f9b930b33c098c55a9bbf517dca8324601"
    sha256 cellar: :any_skip_relocation, sonoma:        "5f695190193021d0a65b81255f758a44fc4feb5bbf4f3f039f2d2b5d663edadd"
    sha256 cellar: :any_skip_relocation, ventura:       "b871e05b6d2c93683de88eec84ce210e0aeebf725ef4a8bf4bed3e6bfc6d5a25"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "598937615ba7bf9fcaf4b3b2bfc7d272477911e7313141e25bf3864f38e41fcc"
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