class BlockGooseCli < Formula
  desc "Open source, extensible AI agent that goes beyond code suggestions"
  homepage "https://block.github.io/goose/"
  url "https://ghfast.top/https://github.com/block/goose/archive/refs/tags/v1.10.2.tar.gz"
  sha256 "c20d0b46aaceb9b21d512ca50dc5c55aa4ab7704d6357adbbb3b966fd1c96598"
  license "Apache-2.0"
  head "https://github.com/block/goose.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "731e240ffbfb0476d9a260362bf020042c8a830e8771351b8bb9bcac58baebe3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7c256829df7fa47697475d10c395eecfa0c915acd8086d315366d791d7e07e1c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d2f14bd78c8a925630ec528cdaa9065de7905fe916678a700a040827b4fb0967"
    sha256 cellar: :any_skip_relocation, sonoma:        "6e435d395f477aeb07e14b3e0558ff75264323402ef2a69921e7d4db6f005262"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d2e6b4a559f32dfe29155e30bd28949a2627bf254fd087de35908aecc38d0ad6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e0daae044aa63f04ccc213968d80125db985576528b1c6abe6906994575fba81"
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
    assert_match "goose Locations", shell_output("#{bin}/goose info")
  end
end