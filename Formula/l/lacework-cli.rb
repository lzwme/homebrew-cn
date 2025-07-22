class LaceworkCli < Formula
  desc "CLI for managing Lacework"
  homepage "https://docs.lacework.com/cli"
  url "https://github.com/lacework/go-sdk.git",
      tag:      "v2.4.0",
      revision: "51ad90eacc000620fea30974c1470e8c3cf27ab6"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "988285c43c5847e996efe85664927fec8da6d57ea5ba0b6b2d51a553fcd6cc05"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "988285c43c5847e996efe85664927fec8da6d57ea5ba0b6b2d51a553fcd6cc05"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "988285c43c5847e996efe85664927fec8da6d57ea5ba0b6b2d51a553fcd6cc05"
    sha256 cellar: :any_skip_relocation, sonoma:        "137f464b7b957a9ebe5473cb1cce4397ff5fa2d5411437d9f4813a48482ffb30"
    sha256 cellar: :any_skip_relocation, ventura:       "137f464b7b957a9ebe5473cb1cce4397ff5fa2d5411437d9f4813a48482ffb30"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "62a802572a146cfe62115472b5de05aed5d2a4cec7ee55dd2dee9915f1405972"
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