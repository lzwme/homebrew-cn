class BlockGooseCli < Formula
  desc "Open source, extensible AI agent that goes beyond code suggestions"
  homepage "https://block.github.io/goose/"
  url "https://ghfast.top/https://github.com/block/goose/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "a06771e8ef434e0daa2d2698743007bdd6ccc4766a38d33707fb0a05a5a16c58"
  license "Apache-2.0"
  head "https://github.com/block/goose.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "36fe8ed7a1bdf57370174a5f47a499439caf2288239807f379989a4ae62aae9a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d1d6e27107111c707ace116b0ffa3eb787d55ed439f1f6de9c75079ed8c3f1c8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c568edca34c17af04314d495c0c13d6582356824f70353c9c5940300a492b669"
    sha256 cellar: :any_skip_relocation, sonoma:        "c2f41048a1120c5e0a0c19874e524314fd2af95e026f68e60d51b5b28211cc58"
    sha256 cellar: :any_skip_relocation, ventura:       "41f30ce3b42ab67bbfc45735bdf51eb545752a45a99b92ce0e26f5d377eeea88"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4614128ad3d3dda8bc6db6e4dcd9047e8223bea131867e80b31331a6f050672c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2e5c0ccf562356f0f59c6b81ea286c929d87614548d23cb1af5ce2494ee21f63"
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