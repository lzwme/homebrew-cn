class Ipsw < Formula
  desc "Research tool for iOS & macOS devices"
  homepage "https:blacktop.github.ioipsw"
  url "https:github.comblacktopipswarchiverefstagsv3.1.562.tar.gz"
  sha256 "eb7067cb9949840650cb62c77b822122f6ae92d5775242941f7625d111e436b8"
  license "MIT"
  head "https:github.comblacktopipsw.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3937624091bcd8ffb2b95fff5fd64dd21069dad0bd83ee5a5a3c9f51ab9dc2b4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0f89ca357f44e0851b5cfbddb78665ca08058c01f395ccdcd4ab13971ea1b241"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f690fc508fd3d77e3045e217123192c8023f8ec1104b2553a9344178093f6934"
    sha256 cellar: :any_skip_relocation, sonoma:        "6a1a190b3e0bfe29c71950bd617e4c6847245e3b561e4cc7e44cf867f4ab8589"
    sha256 cellar: :any_skip_relocation, ventura:       "a6e142a93b564d60ddedcdaf388a04c257461e4acdd6ef3343131dc9421df586"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "22a904c004392135c6120a02ce45405f5c2e37a6bf23f9a68943e2c8adbf1231"
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