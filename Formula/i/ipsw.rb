class Ipsw < Formula
  desc "Research tool for iOS & macOS devices"
  homepage "https:blacktop.github.ioipsw"
  url "https:github.comblacktopipswarchiverefstagsv3.1.567.tar.gz"
  sha256 "d471c297a8393b36c48611c28da86795a94b59f5e76e6198910defa394a46bfa"
  license "MIT"
  head "https:github.comblacktopipsw.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a819c78ae115c8cea471501d1b0e78e4d15343a37bb41178bfd71d25efec2758"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9f2a873860b863894ed7799e21ed7f5b1f8b0ca59637c143eba0c8c99f09aaf0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9ce8751c804a7b3056a5ec8df8d88c0a45326e3f899c3a6a74e943167c4bb16d"
    sha256 cellar: :any_skip_relocation, sonoma:        "dcddf4e933abd894150914d9e098f6abad928609d65f7f3ffa3251e5e537f034"
    sha256 cellar: :any_skip_relocation, ventura:       "703dd24238f81d3cf39c0ea0b175c74bcf5fe8845bf29a63353d2049a80a952c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f9506b9921e06f5617cdd068e6fc3328be9efff341f78d65f87f7004d7e23d59"
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