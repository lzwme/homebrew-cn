class WasmTools < Formula
  desc "Low level tooling for WebAssembly in Rust"
  homepage "https:github.combytecodealliancewasm-tools"
  url "https:github.combytecodealliancewasm-toolsarchiverefstagswasm-tools-1.0.56.tar.gz"
  sha256 "516205967493cb4346e19eed9730ff595b2957dd0c2e0ef29d5c55c570db1f82"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https:github.combytecodealliancewasm-tools.git", branch: "main"

  livecheck do
    url :stable
    regex(^wasm-tools[._-]v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c44cae8c52d807dce9ffc9c4721f1b32fab6836d821802de139a7e6be1ba6447"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "986aa3e6a462d5681873019557da1ca45bee0dd121335f036082d9a5b28378ea"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "df4f73a91123ee899877ed76fc6ff5cc44b51d714839b92bbaf68c9a2ac64d4e"
    sha256 cellar: :any_skip_relocation, sonoma:         "b8dcbc81b7e953f5c7c0a7314e61c88433fb680b5300750c888cdbbce33fd608"
    sha256 cellar: :any_skip_relocation, ventura:        "bbfa34be144017bfbb62ac29a38cdeead9064fe48fabe2c2714fab2a96d7793e"
    sha256 cellar: :any_skip_relocation, monterey:       "aa668f2eb99dab668b5ab7b3bd7d7d09bae7307eedc0639d29e2c27aec2e7a46"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bbe5937918e1957a724acffef240b4f95703c8b99bba32b3f3b83199de71ea1c"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    wasm = ["0061736d0100000001070160027f7f017f030201000707010373756d00000a09010700200020016a0b"].pack("H*")
    (testpath"sum.wasm").write(wasm)
    system bin"wasm-tools", "validate", testpath"sum.wasm"

    expected = <<~EOS.strip
      (module
        (type (;0;) (func (param i32 i32) (result i32)))
        (func (;0;) (type 0) (param i32 i32) (result i32)
          local.get 0
          local.get 1
          i32.add
        )
        (export "sum" (func 0))
      )
    EOS
    assert_equal expected, shell_output("#{bin}wasm-tools print #{testpath}sum.wasm")
  end
end