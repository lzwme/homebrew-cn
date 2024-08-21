class Ipsw < Formula
  desc "Research tool for iOS & macOS devices"
  homepage "https:blacktop.github.ioipsw"
  url "https:github.comblacktopipswarchiverefstagsv3.1.536.tar.gz"
  sha256 "5b1705578ab9d1c81efa7c2f265ae325b4a356628c8e02f8713efd66e9057ead"
  license "MIT"
  head "https:github.comblacktopipsw.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "aaa86b892214b3f6f4183879fb1def483192405f19d4b66410c2b49ac7e0aadf"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "398213672259db1789d599945841c70c76cda57fb38021917a42edb323d852a0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2a710384d2532f9ef5123f29381e9e62ab931185601c7726a7974b7d269f6c47"
    sha256 cellar: :any_skip_relocation, sonoma:         "a12e13922cadd438814439efd04dd43b8cbaef29c63702d978da6d8e21b51671"
    sha256 cellar: :any_skip_relocation, ventura:        "217f5963becb2d13eb890e11b864b7df8a536d8330328d8c471d42627c68d81f"
    sha256 cellar: :any_skip_relocation, monterey:       "64fb8bd3e8688b36982631689555a92711e3683fecd2700d907b03682f0eb38d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "579933f2c2d81551df4601290dddcd26a9aa58c4285256761cce1e5aa5043612"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comblacktopipswcmdipswcmd.AppVersion=#{version}
      -X github.comblacktopipswcmdipswcmd.AppBuildCommit=Homebrew
    ]
    system "go", "build", *std_go_args(ldflags:), ".cmdipsw"
    generate_completions_from_executable(bin"ipsw", "completion")
  end

  test do
    assert_match version.to_s, shell_output(bin"ipsw version")

    assert_match "MacFamily20,1", shell_output(bin"ipsw device-list")
  end
end