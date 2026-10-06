class LaceworkCli < Formula
  desc "CLI for managing Lacework"
  homepage "https://github.com/lacework/go-sdk"
  url "https://github.com/lacework/go-sdk.git",
      tag:      "v2.19.2",
      revision: "c71cecc606a28fd7abd145b3f60b118e4535cd11"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "639d1ba41fecde22e7c74fbe4e66d31025cf0de4bc954949435378e635aa444e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "639d1ba41fecde22e7c74fbe4e66d31025cf0de4bc954949435378e635aa444e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "639d1ba41fecde22e7c74fbe4e66d31025cf0de4bc954949435378e635aa444e"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "1a067bb4b0e46a10854ee10895ac680346d25d76580a87f77796609b1771d576"
    sha256 cellar: :any,                 x86_64_linux:      "3bc09f9439dce9d78567e02c82ee6740e2e42af4c33e8fde82b5ba8f1724a27c"
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