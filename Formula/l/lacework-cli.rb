class LaceworkCli < Formula
  desc "CLI for managing Lacework"
  homepage "https://docs.lacework.com/cli"
  url "https://github.com/lacework/go-sdk.git",
      tag:      "v2.8.5",
      revision: "9bde50ff9eec9188e033486256823a06b35ccd17"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d354c9af9b9d8f1fd9827e9d8ff6d1f65cc1890d89f7974efcb47bd113157c97"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d354c9af9b9d8f1fd9827e9d8ff6d1f65cc1890d89f7974efcb47bd113157c97"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d354c9af9b9d8f1fd9827e9d8ff6d1f65cc1890d89f7974efcb47bd113157c97"
    sha256 cellar: :any_skip_relocation, sonoma:        "0093fd21de15d865cb624dc7aefd81a687f14f173b185311e7e77cd72fb8fbbf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "940bdde483fc6e14cd182d23d4cc3b551ce5be5531928a76b00b95bd6c8f567b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d9083e57bce2846b2ac83b8f29eaac53665af89717a869eb90097ec99feb864d"
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

    generate_completions_from_executable(bin/"lacework", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lacework version")

    output = shell_output("#{bin}/lacework configure list 2>&1", 1)
    assert_match "ERROR unable to load profiles. No configuration file found.", output
  end
end