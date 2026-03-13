class LaceworkCli < Formula
  desc "CLI for managing Lacework"
  homepage "https://docs.lacework.com/cli"
  url "https://github.com/lacework/go-sdk.git",
      tag:      "v2.11.0",
      revision: "b81418817bb9907eb1284426eb766049be7aff9f"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8c8e15f27ca68479946e6325924c662aef340f6e0b6168f34cbaf8c7c869a7fd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8c8e15f27ca68479946e6325924c662aef340f6e0b6168f34cbaf8c7c869a7fd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8c8e15f27ca68479946e6325924c662aef340f6e0b6168f34cbaf8c7c869a7fd"
    sha256 cellar: :any_skip_relocation, sonoma:        "bc3c59e1deb85545df5d5942b1802b67080ea5509b0b29fca7f9215593c76c9f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7ae2b85f169221f1036ce41d7840c25497e209d7607a23910dd3e28e862aa410"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f3f67aab0dfb36b6772e7f37720ac96b5913a687560205bd75422a4544709ae5"
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