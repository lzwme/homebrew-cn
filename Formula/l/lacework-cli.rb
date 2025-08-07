class LaceworkCli < Formula
  desc "CLI for managing Lacework"
  homepage "https://docs.lacework.com/cli"
  url "https://github.com/lacework/go-sdk.git",
      tag:      "v2.5.1",
      revision: "fe4545d4f36acab82e98e2d7e9e14a86dff5839c"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3faefd2d7ab71cc15605ce15811fbadc077bef6420469983894f617b1c04a166"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3faefd2d7ab71cc15605ce15811fbadc077bef6420469983894f617b1c04a166"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3faefd2d7ab71cc15605ce15811fbadc077bef6420469983894f617b1c04a166"
    sha256 cellar: :any_skip_relocation, sonoma:        "70ee813f23805069da0140a50818fc9fc40883037faf9cc14a56fdb765b99561"
    sha256 cellar: :any_skip_relocation, ventura:       "70ee813f23805069da0140a50818fc9fc40883037faf9cc14a56fdb765b99561"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c1ce65ee7b567a67810170da94672b4489d2aa5055810e2e69a9bca32d89d218"
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