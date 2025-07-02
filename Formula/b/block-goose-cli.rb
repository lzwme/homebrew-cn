class BlockGooseCli < Formula
  desc "Open source, extensible AI agent that goes beyond code suggestions"
  homepage "https:block.github.iogoose"
  url "https:github.comblockgoosearchiverefstagsv1.0.31.tar.gz"
  sha256 "c244b88010ceff40420ccb2d45d2f15580a03c2df45b47a8606d245f58f9d22d"
  license "Apache-2.0"
  head "https:github.comblockgoose.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c9459bac4742dc7740b11f301ef1b627525cf2026358a514d478a53ad772842d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3fcc080a5bb9154255f0e2442de1e4c8fc9afb26abfb1a6f95a4b37198c6f4bb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d2c03a4a3867ad592e4e882d92be25f2ecf440acf34050a246cf2fe57a4ed592"
    sha256 cellar: :any_skip_relocation, sonoma:        "6caba94edae0341c559098f80d1974570e6ca92eae8619f3d58e7c06d15b8d75"
    sha256 cellar: :any_skip_relocation, ventura:       "960db1d627614e86924a8b82cb4d538996aa062b07a71047a1fa01b283958287"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "00aa799358a5a1e8591c368f298ef33bd268f77b811bde850870e167631db39a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "82041e3eb225e1b84efd8c4fa66d1a141919e49f4d97a9436df656cff0333230"
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
    system "cargo", "install", *std_cargo_args(path: "cratesgoose-cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}goose --version")
    assert_match "Goose Locations", shell_output("#{bin}goose info")
  end
end