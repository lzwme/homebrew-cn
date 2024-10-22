class Ipsw < Formula
  desc "Research tool for iOS & macOS devices"
  homepage "https:blacktop.github.ioipsw"
  url "https:github.comblacktopipswarchiverefstagsv3.1.551.tar.gz"
  sha256 "756fc0b50eec3ee8a008919f43163f4f905fb4cafc3f068f7bb01018b04b4f55"
  license "MIT"
  head "https:github.comblacktopipsw.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "74f8e07dca9792a837e60b16a70faf5d3d01420710b9dd6ef71f100fb3f02e37"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4b8f52575fa56155002867be59f1c01bbabf7e9ec0c04b44811c870c25fdac3e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "18dcb606bbd0ecfaebba92293edf3722310535a6bd0acbc3fd869ec8d1c2b9ae"
    sha256 cellar: :any_skip_relocation, sonoma:        "3eb89721da71c569bf9d29361c388ae0d0b585c7287779604d44a24d73bd5ea1"
    sha256 cellar: :any_skip_relocation, ventura:       "686fc318c075992262386661319ca913b421d7310bdebb5919add1d7cb62811a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ad43d13aeeed6cf76e9403bd81cf4060ddfc1c4ac8e160e1633110ae561b48dc"
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