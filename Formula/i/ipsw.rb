class Ipsw < Formula
  desc "Research tool for iOS & macOS devices"
  homepage "https:blacktop.github.ioipsw"
  url "https:github.comblacktopipswarchiverefstagsv3.1.540.tar.gz"
  sha256 "11b8a7fc516f1f20362cd398d408afb7d416d9ef319091a0a0d6808dad08597d"
  license "MIT"
  head "https:github.comblacktopipsw.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2ec4e350bc28139fc48897b669526668406d0fb04854037dea098b96df76d736"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "108b646af69f24c53ca1c5cbcd2918ea5b797b992ec09c0f625c3c0304435fab"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cf6626cda388ce93a194b0135bebd22397a656e8f9addc99e3ae70a89be8a9bd"
    sha256 cellar: :any_skip_relocation, sonoma:         "862bff2fd960ddec1cf9dec2a781029886647ce45a7390ad48d8c5511d161d9f"
    sha256 cellar: :any_skip_relocation, ventura:        "7945d9231c20442f25788162538fbce69ed18adc6e8bb8fdacd167d22ce0bcbd"
    sha256 cellar: :any_skip_relocation, monterey:       "fdc775294d1689a3d20401a8b62a544301896c5e53fbf41be23196826291ff84"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3d31a68a5fbb5956160a3546a6e72f23816fc493c5b5a058a35cd5b6943dcc18"
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