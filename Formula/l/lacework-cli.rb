class LaceworkCli < Formula
  desc "CLI for managing Lacework"
  homepage "https://github.com/lacework/go-sdk"
  url "https://github.com/lacework/go-sdk.git",
      tag:      "v2.21.0",
      revision: "9b094a8197fc6776efe5ab1f560a5e3fb56d3f3f"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "110e26e25e60931c62b76962a0334a803cdd17a5de878debb03241ff20047d61"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "110e26e25e60931c62b76962a0334a803cdd17a5de878debb03241ff20047d61"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "110e26e25e60931c62b76962a0334a803cdd17a5de878debb03241ff20047d61"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "3de67b54a5792bbd4319b10ad40a4be1dc45fc8f63ae9d76c15c7b206384bf58"
    sha256 cellar: :any,                 x86_64_linux:      "efc9d8ec3ef78f4236d9a760259d830fb0697de5966131560c1d6cf85392e555"
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