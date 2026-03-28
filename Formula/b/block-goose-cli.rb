class BlockGooseCli < Formula
  desc "Open source, extensible AI agent that goes beyond code suggestions"
  homepage "https://block.github.io/goose/"
  url "https://ghfast.top/https://github.com/block/goose/archive/refs/tags/v1.29.0.tar.gz"
  sha256 "74f0aac3b31ccf439ebce7cbd28406f7a523edc9d3532fdc0423bb44375d201a"
  license "Apache-2.0"
  head "https://github.com/block/goose.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a7cfef5be567369a7ebf1b536333b9df965103b23b1c99c022fc40c8e21f52dc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "74b8c7d29bfadb3b7abe5ee52eac4bb103b7de494f9d5e870974326a882595b9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "10032dc0b06c850c1e58afe80fd17809840c24666d184773ea1eb8c9022bc776"
    sha256 cellar: :any_skip_relocation, sonoma:        "1b92a38e4fa80787843444055e71dc327204caeaa04e6348385f270a0d507a3e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ac5d641be1adbaa80098e78f63e11817e13873e677c3789b0e1a159eeb42708e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "db6e932f829d0b8bade1b074e9982bcd89ed65d0fc485fbe4e0fbfbbdafe25fe"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "protobuf" => :build # for lance-encoding
  depends_on "rust" => :build

  uses_from_macos "llvm" => :build # for libclang

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