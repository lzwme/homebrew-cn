class BlockGooseCli < Formula
  desc "Open source, extensible AI agent that goes beyond code suggestions"
  homepage "https:block.github.iogoose"
  url "https:github.comblockgoosearchiverefstagsv1.0.26.tar.gz"
  sha256 "0cce383568d315e055dffecbc33ed22f11babf27f2e5bbbdff408c9684b7ac79"
  license "Apache-2.0"
  head "https:github.comblockgoose.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "278202fd5cd298d0f3d6d181fdc01981cb40981283551814aefb35c315286bc3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "55f3b2bc38e79fdcd3ce587db0479fbdde034ce60afaaf91012b290c9c72a70a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e088b490f203c7c06c81e3bf7bc86b1b0c3e36833f9e36297f30ba3798fed329"
    sha256 cellar: :any_skip_relocation, sonoma:        "d3e4c7b671b2dd2a8b0bfc1d072c4a52a534f21c8301558140442b79e055c9fd"
    sha256 cellar: :any_skip_relocation, ventura:       "e13a0b894198b124366db523bb06873810fc447981136ade413961818be2502f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a27a56cb19e8addbd4e700b9443dca6979266e48bbb0425681ab810a6d3c0ea3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1483a581fd8f9f2d0ff7300b13321d0a795158f7bd5d0ef0fc58545e4e32bd54"
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