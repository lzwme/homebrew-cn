class Ipsw < Formula
  desc "Research tool for iOS & macOS devices"
  homepage "https:blacktop.github.ioipsw"
  url "https:github.comblacktopipswarchiverefstagsv3.1.589.tar.gz"
  sha256 "6f5b5ccfcd91f07140badede82d3bbf932997429bb4d6bc07c58cc43b8998aeb"
  license "MIT"
  head "https:github.comblacktopipsw.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "23137f2a4d35e9314f40f65c4e1f20fe5f58c295d155c6384e2537015ef68aae"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ae7da58c4ba4f93e67b29c5c59609b3514c8ac87658cba88e5c623aae3c961b6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5c7807f15199b4f83903ce5f052a563983bdfc4be05a1983d1f953b7df79db5b"
    sha256 cellar: :any_skip_relocation, sonoma:        "5a0314df5be45a78e17fd79821b24333745956aa96d20d69ae1778c4d58c6971"
    sha256 cellar: :any_skip_relocation, ventura:       "377e4b9e2396c4c4deeb83e0a30e2ef87618ced7f48aa92efd7a751fc9a4cfdb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1ba9eef2fe14f3d048c98da4b797170f307b847000dab32bb021579207923d76"
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