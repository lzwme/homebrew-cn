class BlockGooseCli < Formula
  desc "Open source, extensible AI agent that goes beyond code suggestions"
  homepage "https:block.github.iogoose"
  url "https:github.comblockgoosearchiverefstagsv1.0.29.tar.gz"
  sha256 "90551b6ef9e2197a55df7f3ccaf50fc1fc7316e63fac6a42a4df98bb9a45e511"
  license "Apache-2.0"
  head "https:github.comblockgoose.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e4bb6883fcbbda578d5805bb3e87cf48d6f297459a9fb6a6efe776ca9faf00f4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2d04608bef72303ec4ddbb05f9978ab219aaba9c13e9b1b5831db11c0cb73410"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e0a2eb116c8cb0d640022fd7c3750d96818258f9027c063f8d7e2d0501163a35"
    sha256 cellar: :any_skip_relocation, sonoma:        "1215d94fd496d36176dfc77846aed2ca5fbbd18eabea880ea7ecd3fc9ce68171"
    sha256 cellar: :any_skip_relocation, ventura:       "bbc489d2f46697c0fc16c712dec69deea5bf0541fe6ab9240f00ac88868b07be"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8f128227cb7ba4e71b711316edd33e4559152386195d6f03b48ff918804a0fe2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e4b485568d6aecdf999dab7458cf152098de979825fd0459548e8ab0907e68e1"
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