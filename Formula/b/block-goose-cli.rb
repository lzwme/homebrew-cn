class BlockGooseCli < Formula
  desc "Open source, extensible AI agent that goes beyond code suggestions"
  homepage "https://block.github.io/goose/"
  url "https://ghfast.top/https://github.com/block/goose/archive/refs/tags/v1.5.0.tar.gz"
  sha256 "27d2027d9d793c1a482b849bd0981e8ca3672dfd97ac6dd83c987047e34f7d3d"
  license "Apache-2.0"
  head "https://github.com/block/goose.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d2451932d660c3bf6ffb663bd49d2af62fe089785d228e70d0b6f3dc801293f5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3ba0efd76446f7053d2dfedf204e7d63c7c73e20d1ba3757dd25bf4df50e0b39"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "88f7b57c0e7275f22b33d90f79f295b3d6e576d663c15df67ba98265dc2cdcb2"
    sha256 cellar: :any_skip_relocation, sonoma:        "276de6a56bf39df49f54f591927f625fdb41e171af39be93b64a838d2a081b12"
    sha256 cellar: :any_skip_relocation, ventura:       "a97dd38265e64168bdf2f9bebeea14ea957c4e46ae5c2a7dde28acc9bc03e9d9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "98f25e865125c99b0279c5d5b480c05ffba793221940727e04d082fbfd240229"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e678b639350e710f0a160f49dfa5aaadc5905fe73d1652979e45909570315110"
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