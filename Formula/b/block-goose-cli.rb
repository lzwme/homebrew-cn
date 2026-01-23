class BlockGooseCli < Formula
  desc "Open source, extensible AI agent that goes beyond code suggestions"
  homepage "https://block.github.io/goose/"
  url "https://ghfast.top/https://github.com/block/goose/archive/refs/tags/v1.21.0.tar.gz"
  sha256 "056dcc3748621aba80b3684975c4c9b1c0a1ed9c89f0444d987366c1d6e42958"
  license "Apache-2.0"
  head "https://github.com/block/goose.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "aa97b2cc8c03ce31ac1e56a550fc34fb221f6c46e51694639cd438d02f5e4bb9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "64e4ae3015dc56a4be868d30470196e2623e5d0d748cdc1dc9357e749f470980"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aa206f77f12b80e8770e75b82278400bef6a90660328dae7d10bcb56d4593daf"
    sha256 cellar: :any_skip_relocation, sonoma:        "9131962b60bc756918dd1c675e9fb0b20296d4d31bb70c1adaae8c3a386a5904"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c59fde80464247d615271e752587dc264b22df4a02ac177b8745486b73634ffe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e6cf5d469a059e70104ffb3835182e8bc4d4df1a7f12e21fac807c1023453160"
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