class Wasmer < Formula
  desc "Universal WebAssembly Runtime"
  homepage "https:wasmer.io"
  url "https:github.comwasmeriowasmerarchiverefstagsv4.3.1.tar.gz"
  sha256 "aa8a47775845bd39da2e5a044d4b88e2d8d1b807137f5617dc6bcc9906ebff3d"
  license "MIT"
  head "https:github.comwasmeriowasmer.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fb53a7d1ad4a45f49277c12e5f60ee685a558ccc227eaed0f299ac235c320514"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ee63f3ff4a755ad8fb7de7a1777b7d442516669688820e402bbe1234a99f01f6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1bbe704cc4b6a060bb4172362f5d167a8cc5cf3eca2d11e537e8101d9d221ead"
    sha256 cellar: :any_skip_relocation, sonoma:         "c359108bb53869bb8f90fd513eecbe10b479c9e25c3b4c6ccda5cc8538a50909"
    sha256 cellar: :any_skip_relocation, ventura:        "033e9180fd1de04d8b4524d5c5523e057862eb6bc04556ed6227d8162c0c7bcb"
    sha256 cellar: :any_skip_relocation, monterey:       "335fcf68ad45638e365b665c09306439d5e48ccd38905ddf3d7ceef72600b22e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4d8c224d76bd7855e1e9d1ce666a81067d24af76cc350ea75f9b74186b7ddf67"
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