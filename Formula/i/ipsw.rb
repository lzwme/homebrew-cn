class Ipsw < Formula
  desc "Research tool for iOS & macOS devices"
  homepage "https:blacktop.github.ioipsw"
  url "https:github.comblacktopipswarchiverefstagsv3.1.612.tar.gz"
  sha256 "6fc0628b84ba663e69e63d379982896ce1590016bd8ffb4c03b3bd3b4c263d5f"
  license "MIT"
  head "https:github.comblacktopipsw.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1be8c4f62d3a4bd36e7f8295b52c538cef509f19055e6e55c6cd39e26b4f80fd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1d7ad5d0948be0d3e9f3b837d1ff5998659f508baf910b4f1402ff55ef53f762"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ba3562cd207900eb3989c7f3dcab12e7ad840fc808baf13fa69b23a9b5c9335f"
    sha256 cellar: :any_skip_relocation, sonoma:        "7ad43a9e4531ee35382079b9638bb5c039c77ed0d6e39b999ae547df77d02556"
    sha256 cellar: :any_skip_relocation, ventura:       "a3c8084562af7b59d7c3c000148865df7826507a048ba416ce9eba4f91e0ccbe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "591b0056a3ae447a83ebed699d6fa571151357a754fcf40d3f05d3ff371a0577"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5bf7cc9c7827e6a700d11ee92484a15e1bff51f5c5d36aeb99cc06844e8bb2c0"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comblacktopipswcmdipswcmd.AppVersion=#{version}
      -X github.comblacktopipswcmdipswcmd.AppBuildCommit=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:), ".cmdipsw"
    generate_completions_from_executable(bin"ipsw", "completion")
  end

  test do
    assert_match version.to_s, shell_output(bin"ipsw version")

    assert_match "MacFamily20,1", shell_output(bin"ipsw device-list")
  end
end