class BlockGooseCli < Formula
  desc "Open source, extensible AI agent that goes beyond code suggestions"
  homepage "https://block.github.io/goose/"
  url "https://ghfast.top/https://github.com/block/goose/archive/refs/tags/v1.14.0.tar.gz"
  sha256 "c0bb782103e75ccb912035274b5b3cec8dbaa0a150f56ecde532dca04d7b82bf"
  license "Apache-2.0"
  head "https://github.com/block/goose.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7cc414460653d0676ce3b757f44efa94a046dcb1389a5bdd0ee77050b34bad70"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0f94dd4501002510bcd6f6eb44064371629a9ba6493d3150b9257986b0d7e966"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "04a8cc97c746cb271f5838940aeebf405387abb794515fb9e83e4b1ce77a77e4"
    sha256 cellar: :any_skip_relocation, sonoma:        "d6b16010e0b013c61495b99951e828a891fec401c8a3914a11ff13c212c13bc3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5cdc44edd9c1305833a7ba3f2016808b79fcecba91a29a109c8b645aa4d50814"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "18a537c968925556e928c966ffa963669958a2248c12e2426571110d7f5e14a6"
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
    output = shell_output("#{bin}/goose info")
    assert_match "Paths:", output
    assert_match "Config dir:", output
    assert_match "Sessions DB (sqlite):", output
  end
end