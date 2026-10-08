class LaceworkCli < Formula
  desc "CLI for managing Lacework"
  homepage "https://github.com/lacework/go-sdk"
  url "https://github.com/lacework/go-sdk.git",
      tag:      "v2.19.4",
      revision: "21f3a257f1af6609a364fc043b00cf1a24a5d45b"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "281e724551483a2eaac5450f1edc500c4334ad9f3fe8dbd77878334460bdee17"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "281e724551483a2eaac5450f1edc500c4334ad9f3fe8dbd77878334460bdee17"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "281e724551483a2eaac5450f1edc500c4334ad9f3fe8dbd77878334460bdee17"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "32ac475a9cc35ad01c652c093e835f8345aeced5b76eacdcab804431aefe3c2a"
    sha256 cellar: :any,                 x86_64_linux:      "a1248dc74fd1066b06dc0a400bed180e1ffc332769d18897983fb24029044d9d"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -X github.com/lacework/go-sdk/v2/cli/cmd.Version=#{version}
      -X github.com/lacework/go-sdk/v2/cli/cmd.GitSHA=#{Utils.git_head}
      -X github.com/lacework/go-sdk/v2/cli/cmd.HoneyDataset=lacework-cli-prod
      -X github.com/lacework/go-sdk/v2/cli/cmd.BuildTime=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(output: bin/"lacework", ldflags:), "./cli"

    generate_completions_from_executable(bin/"lacework", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lacework version")

    output = shell_output("#{bin}/lacework configure list 2>&1", 1)
    assert_match "ERROR unable to load profiles. No configuration file found.", output
  end
end