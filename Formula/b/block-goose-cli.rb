class BlockGooseCli < Formula
  desc "Open source, extensible AI agent that goes beyond code suggestions"
  homepage "https://block.github.io/goose/"
  url "https://ghfast.top/https://github.com/block/goose/archive/refs/tags/v1.27.1.tar.gz"
  sha256 "c93de05254070ffd4c19f4ea3f22c2d7ca551888154addef773d4c56f67561d7"
  license "Apache-2.0"
  head "https://github.com/block/goose.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9eaa52b2e4b4c5dfcec1807d56b3f1269dde1b2d000262d8ac9d7f875b69ce80"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "89c67c00989f631b4f2b2ce20351cacc4f435030c00638241f7186e1bbf211e2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ca4727f1a227ccf1c6f4a92de8603a121d96a4c25f4d603322c18b72f2657968"
    sha256 cellar: :any_skip_relocation, sonoma:        "376b465d7863828c395cb29b26f9da90dc18d33f9e3bbb716724bc256ac307c6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "70a9f46946480a2b4b23305f78b3c0a52064243d1528610c8700c9d47fad2992"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "49ae1865d801af445d01c64f75aaf816aa4fe36ec3e3a607d49d861043a7e993"
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