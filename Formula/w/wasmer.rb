class Wasmer < Formula
  desc "Universal WebAssembly Runtime"
  homepage "https:wasmer.io"
  url "https:github.comwasmeriowasmerarchiverefstagsv4.2.4.tar.gz"
  sha256 "183fd1c28eb778eae53c15d11031a2bf35e7615b22a3d8838e3e2ad0ed2c541b"
  license "MIT"
  head "https:github.comwasmeriowasmer.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f8f53562f6172c55f2a7bf2e158bcb0b73428cb51359dde4be998f024d8b4a00"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b8f141eb949a64544cd2050adc79226ad5a8cfd01d77ced3bc1dd38b9bdb53f1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ecdf8d7d86c18b73113a5c565bfa1b7fd0231e73b00d6c9657f9bea243719f29"
    sha256 cellar: :any_skip_relocation, sonoma:         "8c3ff1485cb99db30aca11650386ba9f38d2a03e05de69fdde3a4a047b0083df"
    sha256 cellar: :any_skip_relocation, ventura:        "3f75d812487b7d36b75b8cd211b6e22a7cad45e56df9f49de35d070d12baddf5"
    sha256 cellar: :any_skip_relocation, monterey:       "24e806b9cecc945c95725a9d6eda6fb5b36df8727658fb779449e99e53d673fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d9fc7ba73d06bf161f80aa57a8f7408b8d75ed380171ec05924e0bd15c3d56fa"
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