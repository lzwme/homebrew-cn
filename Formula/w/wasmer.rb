class Wasmer < Formula
  desc "Universal WebAssembly Runtime"
  homepage "https:wasmer.io"
  url "https:github.comwasmeriowasmerarchiverefstagsv5.0.3.tar.gz"
  sha256 "703e7a3efda6119f4992848948108d25770c9d399f5611583a7d350c295dc6dd"
  license "MIT"
  head "https:github.comwasmeriowasmer.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "70dcdf9676308d6ab3a3a8d4805570ae4d7939e399f397a5b0a127331a292c03"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "45095043827de5f79ff7d19360538a1eded437eaa776a0d2ca2dda28599c6df9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1fa37f5282c8d37b53a64ccf7c424830284e35d632de8642720f1656636f830f"
    sha256 cellar: :any_skip_relocation, sonoma:        "c0849273332b4520eca3ff7d761a6362e9aace0b3642b5299929d503a0af22da"
    sha256 cellar: :any_skip_relocation, ventura:       "7eede044e62a96c1e6d34a8c417de4d5586c0e49758b58e05f031fd558aa6d89"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "904e4a22136c9ce9c7cf16d131afb4fa860ff3d946bb5a905dcad33271911700"
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