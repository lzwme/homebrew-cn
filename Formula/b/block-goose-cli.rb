class BlockGooseCli < Formula
  desc "Open source, extensible AI agent that goes beyond code suggestions"
  homepage "https://block.github.io/goose/"
  url "https://ghfast.top/https://github.com/block/goose/archive/refs/tags/v1.22.1.tar.gz"
  sha256 "2838710ee2dda71118ef9a30ccd7090a142a5a8b95973ea6cafebd25ecf6c4b0"
  license "Apache-2.0"
  head "https://github.com/block/goose.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1f6d0dc594bbc8763ac2615751029b47f3fa9b5747e204e8d02553f424f0cc61"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "81eb5177e1b62a3984f618307420213fff1b8db808b20c71312b4716c599c9e9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "30aba14d102fd3f15546bc98cc16a1d40c9f4dccda4a3984d0550b085bbbe055"
    sha256 cellar: :any_skip_relocation, sonoma:        "02e8b590c2576e4142b893e3737d6ce215cc4b35858dac8dca24d741bc0119b4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b5c96da930d27ab4b44cb63ac8323ed998f70371946bc9fa13070f6d7661c518"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8bc1f526a81842ea387e09bf15fb926bc1f1bca2ab49b5057690a615ef1ece4b"
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