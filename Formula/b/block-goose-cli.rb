class BlockGooseCli < Formula
  desc "Open source, extensible AI agent that goes beyond code suggestions"
  homepage "https://block.github.io/goose/"
  url "https://ghfast.top/https://github.com/block/goose/archive/refs/tags/v1.25.2.tar.gz"
  sha256 "ea4ba3a74528c3bb07d111b82a818111e886bcf2c32d4003e381a74a29fd42d1"
  license "Apache-2.0"
  head "https://github.com/block/goose.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4faf3799fdf993d66c0570a67dda4c4af3b6b2e07a62fa186044b72fad4c6854"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "66b10978d8de5dfd84f500c05f3d97eb6130e6a1dde53a8276f990d2b34a788e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "73d312e23357b1c21c3090436c9b79d9a217063de75f370903b8ab4180fa2537"
    sha256 cellar: :any_skip_relocation, sonoma:        "f03d3f16bb0a72193a9bf28862dd74f776c6dcdd74a7fbb911bbecc756d57bf7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0cd54bc3f921a3cb2964f139f057d739570db7cb0acc3adaf90aef5c89736e56"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fdfc7414d5ba8b2a506f4ccb4c72023b927292028a56808f780a7046b164272a"
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