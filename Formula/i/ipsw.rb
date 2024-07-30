class Ipsw < Formula
  desc "Research tool for iOS & macOS devices"
  homepage "https:blacktop.github.ioipsw"
  url "https:github.comblacktopipswarchiverefstagsv3.1.529.tar.gz"
  sha256 "351b9c8a3b0db18381cf9a429e4a766ecdaf6581a3de91542d6de74a954321b7"
  license "MIT"
  head "https:github.comblacktopipsw.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c30751ec9d405568346442cb10b92a4e4a7a65638619f88850691b3d88efcac5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "823810223688c009dbf001d0b4d847998f14d308672fbc10300d4de6a00c99e1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d7cbd4336366ea4da5640f5be6bc3f64e0503cccd948957c233f9a7f795d7287"
    sha256 cellar: :any_skip_relocation, sonoma:         "d64102cd1d07952ac5a0d96e3f8ae64a3c1345d08030b1f62642793f41520843"
    sha256 cellar: :any_skip_relocation, ventura:        "4c0fb398be024ab701649f788bb493b2e5b8ec42020a4848b4729292aa3b126b"
    sha256 cellar: :any_skip_relocation, monterey:       "a52197f4d33b61275f988caf1a252eec2100fa18eab34c82ed05938b47b39213"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "df9d269ffa534e90fd8ad9a91ea962723cb96401a8eac1a14b6e9361ca4ce013"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comblacktopipswcmdipswcmd.AppVersion=#{version}
      -X github.comblacktopipswcmdipswcmd.AppBuildCommit=Homebrew
    ]
    system "go", "build", *std_go_args(ldflags:), ".cmdipsw"
  end

  test do
    assert_match version.to_s, shell_output(bin"ipsw version")

    assert_match "MacFamily20,1", shell_output(bin"ipsw device-list")
  end
end