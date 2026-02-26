class BlockGooseCli < Formula
  desc "Open source, extensible AI agent that goes beyond code suggestions"
  homepage "https://block.github.io/goose/"
  url "https://ghfast.top/https://github.com/block/goose/archive/refs/tags/v1.25.1.tar.gz"
  sha256 "12cc6e7191383945f23cac831ba00d8f7fa801470c12c1f882b8577dc3996e45"
  license "Apache-2.0"
  head "https://github.com/block/goose.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e10fabf9cd68410d9831afe04521deef4d33e0d273caf81bfd0fbe9b20d2bcfb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3355d345d23d9bbe2c4b5007a78d7b99e8638df2faa07dfb0ba861e9d352128b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c1f224663184d7c4423327e14970b11a5032d088fc0e32bd9376216166342d8b"
    sha256 cellar: :any_skip_relocation, sonoma:        "4a99a29e079ca2cc9dd9ef8f6719b1d5c96f06e9850517dbf8b4f2a25abc1f20"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "623b4539bf3cb98b732768c08b26e41aeed210bb82dfd913b14409346e924e08"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a1686d705ffce01ac3bf7a9bf39f77d372934b3cbd10e39ae5af4789aad711f0"
  end

  depends_on "pkgconf" => :build
  depends_on "protobuf" => :build # for lance-encoding
  depends_on "rust" => :build

  on_linux do
    depends_on "dbus"
    depends_on "libxcb"
    depends_on "zlib-ng-compat"
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