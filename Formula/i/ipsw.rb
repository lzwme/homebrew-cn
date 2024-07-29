class Ipsw < Formula
  desc "Research tool for iOS & macOS devices"
  homepage "https:blacktop.github.ioipsw"
  url "https:github.comblacktopipswarchiverefstagsv3.1.528.tar.gz"
  sha256 "d3fed1900739625b1953f90ebafddc95e75703e5af7a1c8a122285990f7327d3"
  license "MIT"
  head "https:github.comblacktopipsw.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "69152cac8bec76eb8ab23476b1f2230d00abbfe386c50290a5e3d0dafc3ca678"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "434215f037b5d88310df36707f3995f827d03e1064df2487ba91ad8c32157fe7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f3457e0a16d0c09eae55a75e1f6403abd88b9a1827ca77092a699244eb5ee12b"
    sha256 cellar: :any_skip_relocation, sonoma:         "d16a995d6c61df1e3b50a9da370829215865cec27fb5e4b22cdf3dc1d220af06"
    sha256 cellar: :any_skip_relocation, ventura:        "23da631c1e757882a1432786ac2902fce7a02a86800caa57ff270d8f474840d0"
    sha256 cellar: :any_skip_relocation, monterey:       "dd4b96e49438e94375a3e3ee998c076cd75fd3cf83acad4c08b4d43b8b381f7d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d33183eb013002fc0c30d6e9610e3897c38d472be919a8d8bec6eb3d622cf820"
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