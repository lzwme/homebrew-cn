class Ipsw < Formula
  desc "Research tool for iOS & macOS devices"
  homepage "https:blacktop.github.ioipsw"
  url "https:github.comblacktopipswarchiverefstagsv3.1.559.tar.gz"
  sha256 "8c3fdc9d45fd2f71556c18ff323996de3d7e590303b0d873031779dd964b99d7"
  license "MIT"
  head "https:github.comblacktopipsw.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a878560aa71282b734e4d930aa7f8bbb0d9ca925da927e083dbc1ce6e21ecd82"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "49c0a6d93326bc732d726dc25e1cbfbec10c6faf9b1aa06704a56040b3e6b743"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e5e1f5d6ff0c5b4cb1752da8853f61a78974aaaafa0f0b38f5d8c3f94eab1f47"
    sha256 cellar: :any_skip_relocation, sonoma:        "a5d644b228633d4cae530687adfcf9637417a45c9cdb7543771deeb5f0109cd7"
    sha256 cellar: :any_skip_relocation, ventura:       "7418e83b813398b07b49e2ab5752cbbb1735aef79f7b5d4c9ab276e4ca6004fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8d533a38cc0dea23c0934bc613ecf73dc2d94ab754429dd80bff888f493af271"
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