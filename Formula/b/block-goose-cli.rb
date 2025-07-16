class BlockGooseCli < Formula
  desc "Open source, extensible AI agent that goes beyond code suggestions"
  homepage "https://block.github.io/goose/"
  url "https://ghfast.top/https://github.com/block/goose/archive/refs/tags/v1.0.36.tar.gz"
  sha256 "ce751d1a0246dce709922f5ce3f98d090b3f7c1039d08b04e6cb2dd1a1c1093f"
  license "Apache-2.0"
  head "https://github.com/block/goose.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ac78b207b066f5b326df497c7cb278212064e3c94af848fb3cf0e080b60a15e6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1b72cd04e1a4751f853e768be6dd93169f8008bcfea2fe4cff8e373420bc1ac9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "804c68ccec82a596fc471ee5d78832ae14bfca9bf2fc171e6e059d86f6f0d882"
    sha256 cellar: :any_skip_relocation, sonoma:        "a760cbca924ce5e01b2fae8c38171c790745c93ed4cbc9e6617d31908d163afc"
    sha256 cellar: :any_skip_relocation, ventura:       "f92b6b39f9994b7bda90e8055a8a112c0b05ddb856031de85040df4c6fefed47"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c1a7d2eec720b0d95cc93c6f5f8df36799083a2c6035108492d25e4acac5c25f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9b82791d83ed147ea880e775c7273986614cf37f0030c0b703e07b8c1b3fda2e"
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