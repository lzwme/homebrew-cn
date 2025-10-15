class BlockGooseCli < Formula
  desc "Open source, extensible AI agent that goes beyond code suggestions"
  homepage "https://block.github.io/goose/"
  url "https://ghfast.top/https://github.com/block/goose/archive/refs/tags/v1.10.0.tar.gz"
  sha256 "05e7da2210f5a09aaedbb2688976f3809a4525ca5a6f10dbef57f9dbef6cbc22"
  license "Apache-2.0"
  head "https://github.com/block/goose.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "df86b1637889dad3f39edc34dd9c56b6f6918b4dbd1008eb64152259a6c97f06"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b91c42c24af8ca6f70d06aac32cceb78c9609893df1c961e196581523842f388"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "77baa969d4a47c87682c043b1c17186a8d9b67eece0010bc1715f94aff237f8f"
    sha256 cellar: :any_skip_relocation, sonoma:        "83fd9e8d2c1ca531de233b3d0f8144abca94e26ab390711c149cb445a973acb5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fb25dae37162a2595392a864c6a6c58207b225c667281445c3ec5e5ba7eb45d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ceee21052648e733a73d9ce2a29740e1fe2de22ea58e4c91a85efd16e2381bbe"
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