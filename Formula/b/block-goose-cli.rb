class BlockGooseCli < Formula
  desc "Open source, extensible AI agent that goes beyond code suggestions"
  homepage "https://block.github.io/goose/"
  url "https://ghfast.top/https://github.com/block/goose/archive/refs/tags/v1.1.3.tar.gz"
  sha256 "fc8a90edba59d25b30e5fd6977f3dfb4a4f8e6d633959816cd38c869627920e3"
  license "Apache-2.0"
  head "https://github.com/block/goose.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c5cb059698a499e29ffc6308934e64a68060d5aa3651bf1fc8c4c10d0f7548e9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "030aa46aff95bfc521c05978965abacc79af4edd807190c3f0ab328e2fa6ee33"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0abcd0023393e89bb548c68cb54fc43ca400ac5a48701bd39a6ad86c7ec3444d"
    sha256 cellar: :any_skip_relocation, sonoma:        "51310c4b57f8c5d8032f2d8e2557cce2cce243c7cd65e6af05a7d6eecfb5d745"
    sha256 cellar: :any_skip_relocation, ventura:       "c7ff587cf9eb5310ce40fa112f9cb2c01a92ce94583805e18e45148b4128710a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f7d33bdea2193ebb6f765333d891a814aa0952fe04ab727892f7976ded50bd4e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "83ce4f5484e9d978624d6e3b3d6d09daa2e38e5e2af75df25efdd6dd59d05f29"
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