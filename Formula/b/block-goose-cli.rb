class BlockGooseCli < Formula
  desc "Open source, extensible AI agent that goes beyond code suggestions"
  homepage "https://block.github.io/goose/"
  url "https://ghfast.top/https://github.com/block/goose/archive/refs/tags/v1.9.2.tar.gz"
  sha256 "bc153ae68171b50d158a3e3f1c839a5ea15f5e694bbd4738f4f4881cfefb4ceb"
  license "Apache-2.0"
  head "https://github.com/block/goose.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "286b737c23b72e4ab6a184bb88adcf496bf326073ea815a35e6e64b8953f7e8d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2782de32039cc773f5097090d45c68bfd2cdb5295f8fe72600401b7214405888"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8767c883889e0c382326852bf572b3d3dafcefb6e8f4240e45d023b82cba5ed2"
    sha256 cellar: :any_skip_relocation, sonoma:        "9a3d19f739545d675685f8863abd4f436e0d4ed1d9003baf99d058a5945c17b7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "af1624edecad94779191d5b21505e6d5508e896a5f7654658cf40b6bddb876c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1beedc400f493ff96f1ac5cddd439e0d60321a1ef09f385cda38821fbdf46c67"
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