class Wasmer < Formula
  desc "Universal WebAssembly Runtime"
  homepage "https://wasmer.io"
  url "https://ghproxy.com/https://github.com/wasmerio/wasmer/archive/refs/tags/v4.2.3.tar.gz"
  sha256 "e2004e448fadc335ec3dcbcc91acf171aa7098f8b29000ddd937eed02af890c6"
  license "MIT"
  head "https://github.com/wasmerio/wasmer.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6ded03d46c151c20f0e6aa99fc249aaf3dd7d66f889943ff677ed4621ee2e83e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "763daf84034db139f0baa2fba0c70c1f708a5900f1595be5334de3aaa7441f8b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a319ccb718018fda1f0ddd902ad2f0e37ec03bc9bbfb2e97f6efb38acbb4973f"
    sha256 cellar: :any_skip_relocation, sonoma:         "0c61df642e1dd9a311f61fddeffa356329ca66cd21f99ca98538a57508924e43"
    sha256 cellar: :any_skip_relocation, ventura:        "0bdf1f8b2668b11c693126739414ea746356b7cded87823a005a68073dbb38e3"
    sha256 cellar: :any_skip_relocation, monterey:       "e3d0008ce12e3599a48070505c7036e84649d6770ec525732a6aad0cf45db5b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "53f9d7b5ffdffaa1273e890ebf1f6e63f457c61a8aa1dae831adeccfba075ae8"
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