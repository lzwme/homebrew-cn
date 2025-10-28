class Wassette < Formula
  desc "Security-oriented runtime that runs WebAssembly Components via MCP"
  homepage "https://github.com/microsoft/wassette"
  url "https://ghfast.top/https://github.com/microsoft/wassette/archive/refs/tags/v0.3.3.tar.gz"
  sha256 "3aafeefd14143a97b0e8a5c85f428f47ded17fd95214e6cb873bc6574f6596aa"
  license "MIT"
  head "https://github.com/microsoft/wassette.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9d31d3f81d9262c5fc6c51c1d3af0d539889118cd20c554781bdac6e5da13a25"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "59256099e81e3665b51e15c594c396e7efee86e174812a77d52075ea675903b8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "73eb66747709d3f5e0957c008c80c24851ea2fb573a6db178021525e6e040e1e"
    sha256 cellar: :any_skip_relocation, sonoma:        "7ffefd9163fab930ae6800ff5360e2d2c4dcde405e6691c68cbb70d64ee828ee"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7ca2b5dd070e7498dc1636832258aebd0336b1d93cad5f6e1e2a90d7c1223e75"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e2cb75b845823bf7ae6c017f35b668e400b6d29aa797f97f739e1e3c34fc1c3e"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/wassette --version")

    output = shell_output("#{bin}/wassette component list")
    assert_equal "0", JSON.parse(output)["total"].to_s
  end
end