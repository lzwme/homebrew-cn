class Wasmer < Formula
  desc "Universal WebAssembly Runtime"
  homepage "https:wasmer.io"
  url "https:github.comwasmeriowasmerarchiverefstagsv5.0.0.tar.gz"
  sha256 "ad957e7aecf5b2d3813dcb04285625d640a284fcc648d81a3eabca3f0f7eca4e"
  license "MIT"
  head "https:github.comwasmeriowasmer.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0c8ab0cb6ab437e931641c54fc42129df08c6dff634c9e89e86eef267e03916d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9d0925934f04e5b8d54eeeafb82074b553b8101a301dfc7ccc42d0952d139327"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f185ab5ce2c03ff5a22a655b982b9cc3ad9e3981dbfb1452e939d954e76514b8"
    sha256 cellar: :any_skip_relocation, sonoma:        "84ec6b4bb8cb3fd23681cc69374b58569e5992a747a5316decfdcfaaf2cf6d17"
    sha256 cellar: :any_skip_relocation, ventura:       "91554f91c5d0b2ff54f6ba8790f9076185e445c3d58d3ac048d237b872155e4f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "61d75445d7728a729eb433f04fbd9b0196b8ada3c76519716e507dd8fbe64fd7"
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