class BlockGooseCli < Formula
  desc "Open source, extensible AI agent that goes beyond code suggestions"
  homepage "https://block.github.io/goose/"
  url "https://ghfast.top/https://github.com/block/goose/archive/refs/tags/v1.18.0.tar.gz"
  sha256 "4c429205addc61e5fd3a56f2a359f2224e83b784fba4463bcabbd7df0e165005"
  license "Apache-2.0"
  head "https://github.com/block/goose.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "94adaba7393e19a64dc55578526e1b1651f0813b0fb7bfcc3c7f0df1196344e5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "79993008496b287568bf1748dd4dd0767843b17f7c70a8399f55ee63fae0e7c9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9c22de534065163b32cba584d0b2e7571484f9bb6590e3a7676ef86d54c9495e"
    sha256 cellar: :any_skip_relocation, sonoma:        "c038e2b5388ffeb74e2e7c26a50e9cf73c2950faea21889c33fc29153d9877f7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fe413df12fd80b0674b673217c4648dd83a790bb9b03f29ad8101a2d97bc5f47"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6e5e969d0d27bcd72bad3f47637c39a3b9723f696d9ea0f9a2b9f64e41d4fe53"
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