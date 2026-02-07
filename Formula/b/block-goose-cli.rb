class BlockGooseCli < Formula
  desc "Open source, extensible AI agent that goes beyond code suggestions"
  homepage "https://block.github.io/goose/"
  url "https://ghfast.top/https://github.com/block/goose/archive/refs/tags/v1.23.2.tar.gz"
  sha256 "0274686a33bb1368e742a8f3be9c8c4fc485a25fdf86a229582748925d18c00e"
  license "Apache-2.0"
  head "https://github.com/block/goose.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "41c5b91e5dc6c80aa42872edd9eaecbfca8add2a6325c017a52a8567b0b81729"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4ee4b78ef954160713e5b59afa98bf79715f7cb1e3e2436cafea6497ec311515"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "272e068889d499cb0d7f32702e6f5d722b7c0825cdeff713fb4ec904537a1d12"
    sha256 cellar: :any_skip_relocation, sonoma:        "f9a27905bdebe7be2f94251051867daba7abcb1076511365a619c79e4b6c80ff"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "11bb5a507e846553203b20d90714ad2f15424fbed6e8f46e05a3a372f8622794"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "af8361b2dc4eae9fe9a06e9adf0da162b2357877e3a08dfb9da2e47d617b88a4"
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