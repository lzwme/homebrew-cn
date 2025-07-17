class BlockGooseCli < Formula
  desc "Open source, extensible AI agent that goes beyond code suggestions"
  homepage "https://block.github.io/goose/"
  url "https://ghfast.top/https://github.com/block/goose/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "6e412a7a20c236207dfc0b0b12e65f43a9786763731bd28528803340876ca3a1"
  license "Apache-2.0"
  head "https://github.com/block/goose.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3f64914029c6ef969c850fddb4915107f3b0ce1af8850b352ed62d8a12b284e8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "23dec1a3836c3cf6883b804f411e58da0c6569e96fbc43d9c050c64ef0360d7f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b91b8939728a22472b3241bad5a006f8f7872e7d2444ce4fb8fa59a65be497b0"
    sha256 cellar: :any_skip_relocation, sonoma:        "091aa2cf6c960c473beb33b59fc530583012e30b87d6bd06e3ae58919830be8e"
    sha256 cellar: :any_skip_relocation, ventura:       "4e028dc4264e57712e71425c040ccb8b440ca137c76929b1d609874338a94727"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b39173f3a20492cc76db00d76f3ea118ba300cc46ff72eec3aad06ec92f7b691"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f94b23e4f064310c7c0c71d515352cbe70e9cd91d49b67748c83e0622af18eab"
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