class LaceworkCli < Formula
  desc "CLI for managing Lacework"
  homepage "https://docs.lacework.com/cli"
  url "https://github.com/lacework/go-sdk.git",
      tag:      "v2.6.2",
      revision: "b2aa67fbf6c6d9471497c1948caf409f8d4cf6ed"
  license "Apache-2.0"
  head "https://github.com/lacework/go-sdk.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5593626de1e849399211df76700212b8ec4a1a8e03ab623218e86e985ac0fb95"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5593626de1e849399211df76700212b8ec4a1a8e03ab623218e86e985ac0fb95"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5593626de1e849399211df76700212b8ec4a1a8e03ab623218e86e985ac0fb95"
    sha256 cellar: :any_skip_relocation, sonoma:        "e4a687c971d0c46505cf10bde5bd26cff9fb5bf266d37d72ead9bd27f70612b5"
    sha256 cellar: :any_skip_relocation, ventura:       "e4a687c971d0c46505cf10bde5bd26cff9fb5bf266d37d72ead9bd27f70612b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "32e8aba2fab17e84936fa9534b8b352820a4047c564d125fd5564a5c588933c1"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/lacework/go-sdk/v2/cli/cmd.Version=#{version}
      -X github.com/lacework/go-sdk/v2/cli/cmd.GitSHA=#{Utils.git_head}
      -X github.com/lacework/go-sdk/v2/cli/cmd.HoneyDataset=lacework-cli-prod
      -X github.com/lacework/go-sdk/v2/cli/cmd.BuildTime=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(output: bin/"lacework", ldflags:), "./cli"

    generate_completions_from_executable(bin/"lacework", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lacework version")

    output = shell_output("#{bin}/lacework configure list 2>&1", 1)
    assert_match "ERROR unable to load profiles. No configuration file found.", output
  end
end