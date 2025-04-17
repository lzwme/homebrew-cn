class BlockGooseCli < Formula
  desc "Open source, extensible AI agent that goes beyond code suggestions"
  homepage "https:block.github.iogoose"
  url "https:github.comblockgoosearchiverefstagsv1.0.18.tar.gz"
  sha256 "7542d1f35f5bfd1cf47cec749d429e27b9d5c390112139c1b6c3e32ebf5df6ae"
  license "Apache-2.0"
  head "https:github.comblockgoose.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4dacf8aa769c41d727cb53053df4a625ae86b975521dde690703abf5d48a1640"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5a9e7b311f4d66346a5bcb77afc11a3c444e9376d629a61924199d2836b96417"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0efadff8a032f8af551af019794175d770c9e33c30495a487d4be54e666333bc"
    sha256 cellar: :any_skip_relocation, sonoma:        "ab5af4638162c5f88520fed0d05c619d2e14189ae3fac7f479362112029e1250"
    sha256 cellar: :any_skip_relocation, ventura:       "0a5ca706f286598580d5429109679fc6481cd0bdf11d0668b12fc683a18706fd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e4e1ccb0487bb2955bee0019b66cfb278836862dbaa3b467903790527068782e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8e8b080060cc1ca62c9ad9382141b498c1850393970324f96d0e9be6117ba85f"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "zlib"

  on_linux do
    depends_on "dbus"
    depends_on "libxcb"
  end

  conflicts_with "goose", because: "both install `goose` binaries"

  def install
    system "cargo", "install", *std_cargo_args(path: "cratesgoose-cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}goose --version")
    assert_match "Goose Locations", shell_output("#{bin}goose info")
  end
end