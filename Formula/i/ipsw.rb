class Ipsw < Formula
  desc "Research tool for iOS & macOS devices"
  homepage "https:blacktop.github.ioipsw"
  url "https:github.comblacktopipswarchiverefstagsv3.1.531.tar.gz"
  sha256 "39b506c88b8eac59c90d12996578012929b5f43f6835e55ad9a4dab2e558668b"
  license "MIT"
  head "https:github.comblacktopipsw.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7b044866192b90aa766faceee2fbea6d5894491cbb89e20f94c3ea9a3eb16207"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3462eb4dbc74f0be094ac291dc250d16d95c595406acef1469c06165cf0e0deb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e9c084f77e60d300e8a8e66b14918fcec07429e9d4350662fe3a5a603c1a9ab0"
    sha256 cellar: :any_skip_relocation, sonoma:         "893136e0490a20fd00d29d2000f8104897b18a7a642aaaec5230870c76cde33b"
    sha256 cellar: :any_skip_relocation, ventura:        "3f9996601d747e4d114a4166191596c9ec1eb2ba43eb98043b9f0031a0a7afd3"
    sha256 cellar: :any_skip_relocation, monterey:       "c02281aed18f8ba445115a4b0cae71e5358593fc12786e5e0cea42fec99055fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a5035ef0bb3d4d9023420a26c5cfa8de0e955d571fba5afee21b5cb098ce6bec"
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