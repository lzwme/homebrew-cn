class LaceworkCli < Formula
  desc "CLI for managing Lacework"
  homepage "https://github.com/lacework/go-sdk"
  url "https://github.com/lacework/go-sdk.git",
      tag:      "v2.19.3",
      revision: "3d7bc44180304cd409c74283e03325fbd30610e7"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3a8ae86ab4d9c0902e77500cf2c9fea34a9164209e26dbe1d4a36e70d6b4ab18"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "3a8ae86ab4d9c0902e77500cf2c9fea34a9164209e26dbe1d4a36e70d6b4ab18"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "3a8ae86ab4d9c0902e77500cf2c9fea34a9164209e26dbe1d4a36e70d6b4ab18"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "85a5376efa125329791ac854fcf8ff5b6a4a2dffd2c6cd389118bbd590540938"
    sha256 cellar: :any,                 x86_64_linux:      "d83c1299bd08c92c9350de43afafa3b822ac5e03c21aea79878e7209abfb7f43"
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