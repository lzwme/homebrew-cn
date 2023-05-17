class WasmTools < Formula
  desc "Low level tooling for WebAssembly in Rust"
  homepage "https://github.com/bytecodealliance/wasm-tools"
  url "https://ghproxy.com/https://github.com/bytecodealliance/wasm-tools/archive/refs/tags/wasm-tools-1.0.33.tar.gz"
  sha256 "c1c5fc70d3f3e87ce7e19ac72c15df6d915f9c791f0a3022ddad04a1a18e5106"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/bytecodealliance/wasm-tools.git", branch: "main"

  livecheck do
    url :stable
    regex(/^wasm-tools[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f8f4c0212cb97920c03ca1825d27d828f860145a4a27fec4bc4bf6b7cecb1a97"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "394ff1fa128cbe53f7505440f285bb50b0fafdcb92472531939c34495be10582"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f71619ec49c6cf9a8403c32895ef28b9c3174a05640cc483c15c958e6ffb8594"
    sha256 cellar: :any_skip_relocation, ventura:        "1df282d41c6a8a7622d71bd5d53c0406520c189f00f1b8e53edcaaf6e301ea86"
    sha256 cellar: :any_skip_relocation, monterey:       "783904013c840673c421174a2dd3f84e134098597827fd69fad8a516ee550d5b"
    sha256 cellar: :any_skip_relocation, big_sur:        "a9023bdf2c38cf3c729fe84605d0ec6e1c196570d7d50afed0ebcf6532528ae3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5de206aebf4cde2b615e6a595b387c8e961399f05a95f66d89efdb3025b0185a"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    wasm = ["0061736d0100000001070160027f7f017f030201000707010373756d00000a09010700200020016a0b"].pack("H*")
    (testpath/"sum.wasm").write(wasm)
    system bin/"wasm-tools", "validate", testpath/"sum.wasm"

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
    assert_equal expected, shell_output("#{bin}/wasm-tools print #{testpath}/sum.wasm")
  end
end