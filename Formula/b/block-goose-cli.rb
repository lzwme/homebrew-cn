class BlockGooseCli < Formula
  desc "Open source, extensible AI agent that goes beyond code suggestions"
  homepage "https://block.github.io/goose/"
  url "https://ghfast.top/https://github.com/block/goose/archive/refs/tags/v1.17.0.tar.gz"
  sha256 "13adf3275e3c19590b8a0ae768ac271f5cd92597c77c67d77c1ba148fe4d7e0f"
  license "Apache-2.0"
  head "https://github.com/block/goose.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "56a467f7b143a4bfbe57d07f7b2bc6f2f4852b36097da3f7a3436d008e3a453d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "463ff9e94e5e6d05a71e48fe6a6842db28c2178dde1e7e0384774a94c0378f56"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e5efbe8374b76cb792d0edacba29ae4f9c8524c78d72953840064c48868b1b1b"
    sha256 cellar: :any_skip_relocation, sonoma:        "5b5208544ac754bbbcbc026bf8aecc8cce05ec3038281f1b5045677f8d959fda"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "336bd2d82d58d7f2f16f2ad709f411e9934e0222b8a3e5778c53449446797578"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b38d9b273d8bd54634b53cf7bf69817f79b38894000542db2e2103d8521b4b6c"
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