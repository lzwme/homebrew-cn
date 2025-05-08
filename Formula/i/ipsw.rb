class Ipsw < Formula
  desc "Research tool for iOS & macOS devices"
  homepage "https:blacktop.github.ioipsw"
  url "https:github.comblacktopipswarchiverefstagsv3.1.602.tar.gz"
  sha256 "513aca01feafb93a2cd17463bf99c79ee8caa37609bfa7e93a5a314129083226"
  license "MIT"
  head "https:github.comblacktopipsw.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6930d0c420cbe38de25c10a5d0f44aafb4d6fb517c9343e59e4ad05a0b9d7c5e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8628ac79ded85cc17dfe0fd52b5111dbfd9d4179c635afd5235e71883d8b11e8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0496beb579bbdb1fe961d870b63f6f397124afa9eaaf22ea9bcfefa59e76c2dd"
    sha256 cellar: :any_skip_relocation, sonoma:        "9fbd544a4b477c895524f21a1796f4342db2741cec5035a1bccc27b6af80b56d"
    sha256 cellar: :any_skip_relocation, ventura:       "30b8b7767cb8ebff07f32c4eb8e474ac2f1c70d82c7d12552afe5a06607b7df1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c5680bc25f88544e4541f707bfe39e98a0b183d5e2b7147259e9cfa81abf5749"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0e4e8e61960c75bbfba986e2810714a2e825de82a0963a6076c25467c6b07ebb"
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