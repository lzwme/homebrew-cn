class LaceworkCli < Formula
  desc "CLI for managing Lacework"
  homepage "https://github.com/lacework/go-sdk"
  url "https://github.com/lacework/go-sdk.git",
      tag:      "v2.22.0",
      revision: "aa14f0a9a49df6a6f913d20a11d276b1b8e3e58c"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c1ae597a2c22a760fd9dc5f1c80cc8a9f45c99f521827928d771a570630e0be7"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c1ae597a2c22a760fd9dc5f1c80cc8a9f45c99f521827928d771a570630e0be7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c1ae597a2c22a760fd9dc5f1c80cc8a9f45c99f521827928d771a570630e0be7"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "6f98bb16482b9d23d0986c2708ff0ad554c384490ba2da0cf1c3943bce0a41bd"
    sha256 cellar: :any,                 x86_64_linux:      "2e10d8a0a266ea5b5c8d3f2b6ea60d3fadff18765a1a3876e782a463a22598ac"
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