class WasmTools < Formula
  desc "Low level tooling for WebAssembly in Rust"
  homepage "https:github.combytecodealliancewasm-tools"
  url "https:github.combytecodealliancewasm-toolsarchiverefstagsv1.216.0.tar.gz"
  sha256 "320ea681b55c8259ef6bcc842ee46f49d3242351affb76f80271458b4b7802db"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https:github.combytecodealliancewasm-tools.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d54c5a8ee0c38f8a4ad58bb1cf622e2b8178707912fc97d0d127afa001a9e7f7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4914ec0866f596a5012db4b3ec2b3f895f229234faa99476dd923f2bb7af4a97"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aa6e6fd7898f76ca2014b7caf27e882e995d88958c8748ee2c229ff3e4a19cbf"
    sha256 cellar: :any_skip_relocation, sonoma:         "d8ada2919768b71391955c2dcca520f407d70b0a97785181e4e35da77754b77e"
    sha256 cellar: :any_skip_relocation, ventura:        "d853ca36a1aecf6ace2a0915ec0e1b5dcffb62b31bcc66916a2bfc8cc2aad1df"
    sha256 cellar: :any_skip_relocation, monterey:       "de78ec1eee9eb067e6cd3c2c3953bdd476352eeec6a9407d024249f7cc3b29c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3c80a2f6203d909287dad238b13be83b73dd9765d2c0c6745008796807f63596"
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