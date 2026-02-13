class BlockGooseCli < Formula
  desc "Open source, extensible AI agent that goes beyond code suggestions"
  homepage "https://block.github.io/goose/"
  url "https://ghfast.top/https://github.com/block/goose/archive/refs/tags/v1.24.0.tar.gz"
  sha256 "cb3e9fe24fe52ca064c61ccaee8321e9b238851cde2e47f6f8adcf61cde2a739"
  license "Apache-2.0"
  head "https://github.com/block/goose.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0682d91a10860b34688599105faa40abdbf8758c86ab5b536b9f6fde5d52afab"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6cd17a59f45acabcfd2aef280a551da2fb1aa813cf52ee393a627747a305b6ff"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cc53d5c11a3cdb169f9e148a6dee669092b6ea7aad6357e91e9b3b2d7fdea64a"
    sha256 cellar: :any_skip_relocation, sonoma:        "b89c87a8be435579cda97fcbc1cebf2cdfe7c26ae232e0296919d51c730f75d4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0e0316ad0321849c0976e85323f185defbeba53b65fd2e82b1a2afa5882d125f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "73f4dc16c45ad4909e425d7bbea59299ed0a425a1c26e06217913bdfbf5b9201"
  end

  depends_on "pkgconf" => :build
  depends_on "protobuf" => :build # for lance-encoding
  depends_on "rust" => :build

  on_linux do
    depends_on "dbus"
    depends_on "libxcb"
    depends_on "zlib-ng-compat"
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