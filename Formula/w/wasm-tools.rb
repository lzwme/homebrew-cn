class WasmTools < Formula
  desc "Low level tooling for WebAssembly in Rust"
  homepage "https:github.combytecodealliancewasm-tools"
  url "https:github.combytecodealliancewasm-toolsarchiverefstagsv1.219.0.tar.gz"
  sha256 "6d127c70c56d873b3e99570fb6cdc76f5877688abf94f6e2dea905c5291ab751"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https:github.combytecodealliancewasm-tools.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cce2affd74d139c71f28540a3d3a3f8220d9b07eb92f245d671fed638a652de2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "02531efbebb19ab582df03acad594ebcc043bbf5202b69832e4b293ec2a884e4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6a6ee6d3cb9709466dc2b63033ad8f1b5d7896be306f125166e19aecdc635084"
    sha256 cellar: :any_skip_relocation, sonoma:        "c73809e72806a50f73243d1d9a794cbf72d723cf3a6f5d8f8ee2c3ba42782f58"
    sha256 cellar: :any_skip_relocation, ventura:       "dc021d01760bd2c96f7a4b79eee044fa572a00358384aa9662174c8a66e6ff5f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4ef3c5f1a41c92d1bfd0de7f50073872e1f2b17fb71def919d11ccc47c1425a5"
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