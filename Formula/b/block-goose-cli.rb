class BlockGooseCli < Formula
  desc "Open source, extensible AI agent that goes beyond code suggestions"
  homepage "https://block.github.io/goose/"
  url "https://ghfast.top/https://github.com/block/goose/archive/refs/tags/v1.22.0.tar.gz"
  sha256 "08b4655c75ec0551dd01b4927e19c23fde4645612d478d8f0eb4b5fbb70ba52f"
  license "Apache-2.0"
  head "https://github.com/block/goose.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ce83ed6beb04dd0213706889bf73e15d2bc85234fa17f1da5dd252f8a1a02121"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ecf96a7dba9ddd5336642dd5478b70eef07290a2b2e1775d21219b6821a4acc0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "24adab0e80c9f264a764c63466370a504f0a2a565c44ba86f65e4f167d5b3658"
    sha256 cellar: :any_skip_relocation, sonoma:        "ba94e6e886c2091e05561585a0815203532783d4f09b9456d99dc59c7f90d098"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0829a2f51197b27997dfcc99672468c7d50d4ddb321c4a52ad1bc93ccb199999"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dee66f73e65455df6b9a6f2239b70b95a955513f1188ecc6c4c2743a2a96a9bb"
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