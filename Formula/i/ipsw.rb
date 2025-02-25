class Ipsw < Formula
  desc "Research tool for iOS & macOS devices"
  homepage "https:blacktop.github.ioipsw"
  url "https:github.comblacktopipswarchiverefstagsv3.1.575.tar.gz"
  sha256 "6b668e2a5d9fb4b21dfbfe8742c6ae07b907743499e5e5a4b81ce42d15d3868c"
  license "MIT"
  head "https:github.comblacktopipsw.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9e9e2f1b9c8f2ee559a3b9f88ecded356e4a58e3fea7415ccd895ae82fcad43b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3264ce9a77ccc7ea1bc316b4bdedc15a5b921d079559c88fdbf4d73967d46085"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fb5f7ed0d85d1d96e345bcee098032962e4a6177283ead4588c95e27e11de1fd"
    sha256 cellar: :any_skip_relocation, sonoma:        "6aa23e2b48c07b1380a302bde29033cc2dc3f31fccc0ad12ec0a376204444e0c"
    sha256 cellar: :any_skip_relocation, ventura:       "30e6f2360ab4e8ef0620186cf7845ff1f19c9a3ca2fe3900f37460e8cdede339"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a849ecb8cf6e62a8afd42ee4e8cf99f7e121646bc06af92b6bd536b10a346441"
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