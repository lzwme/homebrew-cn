class BlockGooseCli < Formula
  desc "Open source, extensible AI agent that goes beyond code suggestions"
  homepage "https://block.github.io/goose/"
  url "https://ghfast.top/https://github.com/block/goose/archive/refs/tags/v1.6.0.tar.gz"
  sha256 "68b48b038643fa0d815969726cd00be76f261721636fb3812d336e93c93d396f"
  license "Apache-2.0"
  head "https://github.com/block/goose.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a04cf048b19829c2011e8dfc322d364f67fc6553e80c11731fc880940eca7cf8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "26b736c7c5d468f2e4c8c47d10b9e1e15df328f0a5299656cb5d018ded6c4107"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "39034c9b58c35102f360f44a1ed2c31e934c80246ccae0163ac0d3091bd0a197"
    sha256 cellar: :any_skip_relocation, sonoma:        "6a41aceaae52b040cbe43001cb8c7e9cccc0e0dabc80c7553f52ad667e632b08"
    sha256 cellar: :any_skip_relocation, ventura:       "be31319bf914a9c3b27a7afc0f845af6391b7a86d4545afadd17894226180135"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "162e60c4a10339d6c5bfbb58bcf34a5b0ed8fa386bdd897c5db60b7b8609185b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "789d1ef72bfee51a523715c39aa7662b97e9f634eaf668d0202cd0ea7e5ab872"
  end

  depends_on "pkgconf" => :build
  depends_on "protobuf" => :build # for lance-encoding
  depends_on "rust" => :build

  uses_from_macos "zlib"

  on_linux do
    depends_on "dbus"
    depends_on "libxcb"
  end

  conflicts_with "goose", because: "both install `goose` binaries"

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/goose-cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/goose --version")
    assert_match "Goose Locations", shell_output("#{bin}/goose info")
  end
end