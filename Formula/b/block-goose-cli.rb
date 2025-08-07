class BlockGooseCli < Formula
  desc "Open source, extensible AI agent that goes beyond code suggestions"
  homepage "https://block.github.io/goose/"
  url "https://ghfast.top/https://github.com/block/goose/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "54d42639db3e3b1b75d586210513aaa3e8b06059d3bf73d33c9afba88a5b76e8"
  license "Apache-2.0"
  head "https://github.com/block/goose.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0232dcb8425c1b49bbe5c757fbdf27ea00aaed012941315a1aa31ac683108c67"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "61535685d19f6fc50e026b7e4b949489c37368ee645b784a3797bca0fa006652"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1f3b92aaa8cd48b89c7b66f809ac78bb16187095c7a0b52f421b0bf90952b088"
    sha256 cellar: :any_skip_relocation, sonoma:        "5dca2022b016b943aeade74e5013e01315fb8b9810d5b75631e0fe17e43fda3f"
    sha256 cellar: :any_skip_relocation, ventura:       "469e91567e762e943a33318bb0509195127d34b3b93da01c5e47a198e16463ae"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5ad1fadf6b92d9ba7597f17540bf3048580bb831f3bf65ba13f29d68138c9e49"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "35206e29e596f8d6de87bb93576014a70a8a9021d26a4dd37321ffead991313f"
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