class LaceworkCli < Formula
  desc "CLI for managing Lacework"
  homepage "https://github.com/lacework/go-sdk"
  url "https://github.com/lacework/go-sdk.git",
      tag:      "v2.18.0",
      revision: "efc5d102d2871d1f2b499ffebfb89af792760b50"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c9539d077c3209aeb21fd7640e70d9e2cf49197638079419fd434d65b826a89e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c9539d077c3209aeb21fd7640e70d9e2cf49197638079419fd434d65b826a89e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c9539d077c3209aeb21fd7640e70d9e2cf49197638079419fd434d65b826a89e"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "5d657febf50474418c5dd1adab78d776905af32f455d094edead339ec10e71ca"
    sha256 cellar: :any,                 x86_64_linux:      "74e60f65a45008fbbf9f357bc5b914e8ea254193795eed6eb86d068d39b3f9b9"
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