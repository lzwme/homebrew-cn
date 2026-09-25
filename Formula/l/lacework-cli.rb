class LaceworkCli < Formula
  desc "CLI for managing Lacework"
  homepage "https://github.com/lacework/go-sdk"
  url "https://github.com/lacework/go-sdk.git",
      tag:      "v2.19.1",
      revision: "ce6c365de09686761e71f43d5890051f193883f6"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "375ad901cf27857bb336f47186256c6172235fcf6ebb939a04013215e34ff342"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "375ad901cf27857bb336f47186256c6172235fcf6ebb939a04013215e34ff342"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "375ad901cf27857bb336f47186256c6172235fcf6ebb939a04013215e34ff342"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "3c1c059125a23e3294908ce23574c89aaf7c706ac93003463cc961123f55b249"
    sha256 cellar: :any,                 x86_64_linux:      "f28aaf92133167f0c820642de3c3ef64587f161d998670805fe38c7fa2b6515c"
  end

  depends_on "go" => :build

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