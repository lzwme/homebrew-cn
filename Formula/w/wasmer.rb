class Wasmer < Formula
  desc "Universal WebAssembly Runtime"
  homepage "https://wasmer.io"
  url "https://ghproxy.com/https://github.com/wasmerio/wasmer/archive/refs/tags/v4.2.3.tar.gz"
  sha256 "7e398feaea53c419abee6cf8199f717f710ca7b7501eeb3aff1a3782883f007f"
  license "MIT"
  head "https://github.com/wasmerio/wasmer.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dc66f7bcba7fa7cb67c06471c069784af5cee40e302a0bbe136d1693867448b1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f637d5919763925bc68e770594a0f735a47b1f5190fe8dc2e8a7afc7f2f1dac3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "85686c33f6c6ec6c7e87aff11102302557d81b0633f43829344108046e0855a9"
    sha256 cellar: :any_skip_relocation, sonoma:         "85c86b4ab552b2377e42ab5eec1832c7531f2fade286084a5c7b45548d9aca44"
    sha256 cellar: :any_skip_relocation, ventura:        "25f0b304a47a3c84e593b7101dbdf00daf1639705c32effa4d789ca9607853ab"
    sha256 cellar: :any_skip_relocation, monterey:       "0368ce3cda4d9c9950abf65ac9c9c52fc751f7d9542e105576b1cbb1fe8c6a3c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "09c3eb1289b6f562ca2f0fae69ef1fc525d9b7f8e67af377c58beb331b7ef940"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build
  depends_on "wabt" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "libxkbcommon"
  end

  def install
    system "cargo", "install", "--features", "cranelift", *std_cargo_args(path: "lib/cli")
  end

  test do
    wasm = ["0061736d0100000001070160027f7f017f030201000707010373756d00000a09010700200020016a0b"].pack("H*")
    (testpath/"sum.wasm").write(wasm)
    assert_equal "3\n",
      shell_output("#{bin}/wasmer run #{testpath/"sum.wasm"} --invoke sum 1 2")
  end
end