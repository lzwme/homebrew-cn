class Wasmer < Formula
  desc "Universal WebAssembly Runtime"
  homepage "https://wasmer.io"
  url "https://github.com/wasmerio/wasmer.git",
    tag:      "v7.4.0",
    revision: "32b50f8b600efa8e2d5f88593c453139bf1ca222"
  license "MIT"
  head "https://github.com/wasmerio/wasmer.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "54e0da72e14f8836f604dd0ddc113e1a7191f6e81b4f6a806d5996035e1f68c4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "09744c701392df3cbeb287be5034d7a9f672905bb34ea886b3b24a7822fdfb1d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1154738be5fdaff67f0a02d0a52ebbee2f334804acad3e5bb3ffec32be645476"
    sha256 cellar: :any,                 arm64_linux:   "e0400226323375d0938a438e05da5537b51a30368fc805fc707f9d5072c184bb"
    sha256 cellar: :any,                 x86_64_linux:  "c8e2a12135107027dabd014d84d360ff6c803de212b702f2ff0ce0b3aa14785f"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "wabt" => :build

  on_linux do
    depends_on "libxkbcommon"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "lib/cli", features: "cranelift")

    generate_completions_from_executable(bin/"wasmer", "gen-completions")
  end

  test do
    wasm = ["0061736d0100000001070160027f7f017f030201000707010373756d00000a09010700200020016a0b"].pack("H*")
    (testpath/"sum.wasm").write(wasm)
    assert_equal "3\n",
      shell_output("#{bin}/wasmer run #{testpath/"sum.wasm"} --invoke sum 1 2")
  end
end