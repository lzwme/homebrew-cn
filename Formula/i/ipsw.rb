class Ipsw < Formula
  desc "Research tool for iOS & macOS devices"
  homepage "https:blacktop.github.ioipsw"
  url "https:github.comblacktopipswarchiverefstagsv3.1.588.tar.gz"
  sha256 "8dcc98bf9388307aeb86364132cd5f303051ca46a59e5bc6a8d4f1820f3e4a79"
  license "MIT"
  head "https:github.comblacktopipsw.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b05a09f210aff507df3f253ed8ebba111076662f4e803f8f8c51c319e3b0a1d3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "828bec973767221cbb5db3c5e1ca627f69d8920d93e7cb174d39014777b4ca5b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d7ac2c1b9df3d393aca50d37ab1898792994aa0cf3ab9b9cc55f48f3b43da453"
    sha256 cellar: :any_skip_relocation, sonoma:        "316cbcc1622c7e1e63a8edeff8063fd5483a49bd54d3ee8f2292cf716e4e236a"
    sha256 cellar: :any_skip_relocation, ventura:       "ce1c2b84e8e943a44cf8974b582db2614e0d769a3679a660f84e5c0e2768ef76"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "05289eb054cb17cc21551ca109617160f1472d63d71fa24c3e6989a01b0a9a56"
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