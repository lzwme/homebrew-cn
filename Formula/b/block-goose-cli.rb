class BlockGooseCli < Formula
  desc "Open source, extensible AI agent that goes beyond code suggestions"
  homepage "https://block.github.io/goose/"
  url "https://ghfast.top/https://github.com/block/goose/archive/refs/tags/v1.13.2.tar.gz"
  sha256 "02827beeaa9425f93f6198d51df4dd7d90a5d567162fd4633aa58e79cbf6b6cf"
  license "Apache-2.0"
  head "https://github.com/block/goose.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "be4e292b031c38f95e0c87a14532e416570c5b106075b3c4f52b0921da1c9cd1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a99c36ce4a141d3265e3fbad378de194f4273e57bd5067be9b3166804b948bd0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "63b7854acbc440266a3f1b3fcee2304f4b176213a1e892acb301066d367e24a3"
    sha256 cellar: :any_skip_relocation, sonoma:        "f331396e902adb6e8ae81fb96a677632be67cd285a1aaf246f41f5e2e3b8b5fd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fc39c04c22f79e2b8ce0894060aa0f7a7600241ef8f850ee2d100ca20a9c1ea8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "337db6cfd0a42fd6118d05ae7486a68f85c37e29c1dcf5ecaaa1e18efa982372"
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