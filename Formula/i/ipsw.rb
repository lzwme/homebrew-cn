class Ipsw < Formula
  desc "Research tool for iOS & macOS devices"
  homepage "https:blacktop.github.ioipsw"
  url "https:github.comblacktopipswarchiverefstagsv3.1.570.tar.gz"
  sha256 "b34fac82b13f52c549a7e3ab92f99bfdf6fb9d78fbbee1794163f2ac63c530a3"
  license "MIT"
  head "https:github.comblacktopipsw.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "01786bbf99cc96326b626e990891d20ea8079f661692ae8a9c430edb349ea4b2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "01c765eeb9314f65949b3f28c19aa863e44d77eee613ea68edd73946d597ecb3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c0e6c1dbf3b382bb47dab5b6e786a76ca91ebb77d67da14e56bef2992d2278f9"
    sha256 cellar: :any_skip_relocation, sonoma:        "ba19d88ce7414f80c7fa1d2abbc657533045300ce59a4003463ac5902b88c078"
    sha256 cellar: :any_skip_relocation, ventura:       "9dce5cb9190ed302922a64f2f218d49cafd153f7add0a8a8740672ee9922d434"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "60757d62a40658c4c6b9f3caff56a1dab138a4f23a2a375469e4ab630e8b31c1"
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