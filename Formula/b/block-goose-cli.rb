class BlockGooseCli < Formula
  desc "Open source, extensible AI agent that goes beyond code suggestions"
  homepage "https://block.github.io/goose/"
  url "https://ghfast.top/https://github.com/block/goose/archive/refs/tags/v1.7.0.tar.gz"
  sha256 "99cc04698686308db5adcea46e9a9dcf112df54118ccd8e4b72eadd48db6a4ad"
  license "Apache-2.0"
  head "https://github.com/block/goose.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "386c47c732df8f156c99ee0e5615b0765a29f2875941f423731aac9a5d1fc0d9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1d010506a288027b7d0f1828350fa64ebc4ef436ff9152d94d035bb8e87b7bc9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3d54c154280041ccf05836d71ebc64ba06ba59428ee37736a87d6c19b6843213"
    sha256 cellar: :any_skip_relocation, sonoma:        "f5c8191d4cd9c90ea8a7f883244a25517cb1f21a060eec6ec7ccdf198f172e59"
    sha256 cellar: :any_skip_relocation, ventura:       "5f141e9c1ecffa8b6341544350296e4487da6574099b2fbe5cfdf4b26142ad27"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4f863844e4af521b73e9e11049f9f8fac3a59b0ebfe28112077f1d4f5a09c324"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5d18a96d5ab5d6c2b7bcaa8f9d8e5df589d655b21f006e903ae7d88aa3f845b7"
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