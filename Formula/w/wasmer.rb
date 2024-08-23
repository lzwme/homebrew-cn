class Wasmer < Formula
  desc "Universal WebAssembly Runtime"
  homepage "https:wasmer.io"
  url "https:github.comwasmeriowasmerarchiverefstagsv4.3.6.tar.gz"
  sha256 "b19456d33958d36709ba252c8bb76cbfbbd214bc8bb105e44d04f4204ea42fe8"
  license "MIT"
  head "https:github.comwasmeriowasmer.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "677601a5844b1c3d4514a5f669ff1c205b66fd8e80c83ff7d9f5c9ad46b8fdba"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2c3e1dc32cbc721ff6837866b74e3df55548890270eb65afea599172711d4874"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ba41f85daf6a3e0cc97eb6bd3f6ab25eaf5702429aefe1868dd368b12594fdf0"
    sha256 cellar: :any_skip_relocation, sonoma:         "16e2033ed7c11a9875802796153e7234a2b2f0717f13d85a03209bb32f5476f4"
    sha256 cellar: :any_skip_relocation, ventura:        "327b3c2fce1dea54af78b48036f76460054798bcb43bf7d4a92faf193dd56d93"
    sha256 cellar: :any_skip_relocation, monterey:       "b6fe9cefdfaadfd850c6faeb2f610c088b84e889ec9e3082f4262a7ef0f63dca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9a40e67ecebbb1e34149daaa69317f4a40ef54424a6b1e8edee5519f7567262b"
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