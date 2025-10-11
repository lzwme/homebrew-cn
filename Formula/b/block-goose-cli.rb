class BlockGooseCli < Formula
  desc "Open source, extensible AI agent that goes beyond code suggestions"
  homepage "https://block.github.io/goose/"
  url "https://ghfast.top/https://github.com/block/goose/archive/refs/tags/v1.9.3.tar.gz"
  sha256 "189f9b0c67696b290d116fc12c536476a3c7ce0767d6ee4cd5a6dd8e2c70f898"
  license "Apache-2.0"
  head "https://github.com/block/goose.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cfdb08dacab2eb814ea63f2f4020d047991c19d251f0cd1624cc63b6cf9930c8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3b9815f199908e4190299d39f0e103f9cfdc424dbda59dfed1d29366c7475fc6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ebc0d492d10a49193b51b92737c81f87681d1b80dc97b4e09452d92685d86709"
    sha256 cellar: :any_skip_relocation, sonoma:        "75db57ad581d75fff227c0b3556f9e053bf6c1decb80bc6a1fdcf2ef74f3cbb3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b583af4df0c791c9d866c5a3d67a64f576aa28ef3267d94ba5fd7baccfa121d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6f62ede01dbc91aa9edb83c11c77101c5fb8601d9c579193c31f991e6f62e7dd"
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