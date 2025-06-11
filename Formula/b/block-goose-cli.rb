class BlockGooseCli < Formula
  desc "Open source, extensible AI agent that goes beyond code suggestions"
  homepage "https:block.github.iogoose"
  url "https:github.comblockgoosearchiverefstagsv1.0.27.tar.gz"
  sha256 "3207d091489c0b758107bf916bf8a56eaaba099bb2ac9e67424bdfe7299a76da"
  license "Apache-2.0"
  head "https:github.comblockgoose.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5cc30dda387a86d215332731835d8540a918ee474f357340c5fe17d6f4d640ba"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3276694e5eaa76843524aa7344204131071b1b702c4a061ef1792a2bac41ea41"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a2687cafa81676ee66123f2e021aa259c157d35c89d822820ea3270a8ffe090b"
    sha256 cellar: :any_skip_relocation, sonoma:        "15e1796adff3f3126ad551f9c1a590f2234349ae0e1e1d05ca04a6289ed415f1"
    sha256 cellar: :any_skip_relocation, ventura:       "fcf572dd86a036d4eaf7ac25cd59469e1522c0e9bb9a2df28033b2575704d2b1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "087092f69f4e1b1af96578b36b3fd805751717d088c5b0c4c4a33b05441562e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c71cc72881aa3653365def16117b6d91c4008805f4440d844a0412beb0d94cea"
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