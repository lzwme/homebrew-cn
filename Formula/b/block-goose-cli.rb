class BlockGooseCli < Formula
  desc "Open source, extensible AI agent that goes beyond code suggestions"
  homepage "https://block.github.io/goose/"
  url "https://ghfast.top/https://github.com/block/goose/archive/refs/tags/v1.26.1.tar.gz"
  sha256 "4cec95838a89b0b8451af99933444809c0e5fa078e9f0b5f35d33995a027b360"
  license "Apache-2.0"
  head "https://github.com/block/goose.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e7c43afb25993725ff818af883e549bd6390a1383bbd8650196aa8d927f5b5ec"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b1287439e5b36615eb8d96c8d6352958ae869e4c2c8102442fb39f92e398bef3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c22e27806dded0f1732e2c4a0e5716c782d54d7d6d0611f343d758fa8e2d5aae"
    sha256 cellar: :any_skip_relocation, sonoma:        "7a97583f7c0916362268df2d99d0fd365bbba4f411e7de7b907fe5307d63dc40"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "626e19ad14adac4eb87652e6c526ac8f8b6f1f2f5c8576b4281430529f5c01a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c4b8400772afb8030aa8084622711ef535320c6c4f1b2b930796d0037770d398"
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