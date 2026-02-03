class BlockGooseCli < Formula
  desc "Open source, extensible AI agent that goes beyond code suggestions"
  homepage "https://block.github.io/goose/"
  url "https://ghfast.top/https://github.com/block/goose/archive/refs/tags/v1.22.2.tar.gz"
  sha256 "dca232be7bd4786e433cb6bfa5d080f9219ba21ecf80cc6d373b46b864699b94"
  license "Apache-2.0"
  head "https://github.com/block/goose.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6fb1ce06a82c5b70d3ebbe18c3e710ca5d90ea84816e1b5728872bb241025c53"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7ccd7330be3f0cae8b91876448bc1a3cacc190ed831c671fe5ac10d736116b61"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "831015e95bf78248f16043fc66834f56b6f71707941e351752c4fd6e0522f6f7"
    sha256 cellar: :any_skip_relocation, sonoma:        "d1c4a4bdbadfdfe0be96859ea9dc02def900baa9713dd6b40ced50ee490bad9e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6d9551bfe9ade98d7f450d3206b7b3f88f334ad32d434781f1cdbccc9606aef9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5066bd8591978902655e7c0a504d7da0ec39a5b8d0d0c931a3d5b47bffd1b543"
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