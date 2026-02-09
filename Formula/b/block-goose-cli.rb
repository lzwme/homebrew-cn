class BlockGooseCli < Formula
  desc "Open source, extensible AI agent that goes beyond code suggestions"
  homepage "https://block.github.io/goose/"
  url "https://ghfast.top/https://github.com/block/goose/archive/refs/tags/v1.23.2.tar.gz"
  sha256 "0274686a33bb1368e742a8f3be9c8c4fc485a25fdf86a229582748925d18c00e"
  license "Apache-2.0"
  head "https://github.com/block/goose.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "71c71da53142e15f75ef92444caa5cfc190c64a307369c7f8454c8d01fa1eb99"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3981b58c485f55ef366861adc8c876a1f66b1c706a18be4a49c420cac2e0ae54"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bc2284301c5ff6d10b6eb0216a6d82dadc753285d2b792ee9a0c37a4601cc50e"
    sha256 cellar: :any_skip_relocation, sonoma:        "b1d93904a9e1c2a9ff794eaba2ccf8b40ceb092724c7db2d5d01e907d3af31d2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "65a8a071f68dde549b690054bceb1dddce148f4ab57198114bd0ea033b62de9e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0d4621837d204a399380bc286bbb367c6bd673eb133007e439ec7b00b90a16ac"
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