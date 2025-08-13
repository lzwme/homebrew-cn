class LaceworkCli < Formula
  desc "CLI for managing Lacework"
  homepage "https://docs.lacework.com/cli"
  url "https://github.com/lacework/go-sdk.git",
      tag:      "v2.6.0",
      revision: "bbbf90d93bb0e1581c39edd9ddc7a981e2192fbe"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fef441e35b463825c570122655ceadd39ebe0f07c21a5a70bdb2fc3d32fb3ef1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fef441e35b463825c570122655ceadd39ebe0f07c21a5a70bdb2fc3d32fb3ef1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fef441e35b463825c570122655ceadd39ebe0f07c21a5a70bdb2fc3d32fb3ef1"
    sha256 cellar: :any_skip_relocation, sonoma:        "caa4be3fbd322c11f5e0701f8cf484fb0d2c028ec81508f1019741544b289956"
    sha256 cellar: :any_skip_relocation, ventura:       "caa4be3fbd322c11f5e0701f8cf484fb0d2c028ec81508f1019741544b289956"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0e501e8cbfd62faf8d844eaede3196cda1bf99c6467d424323cf7ac05c8c6753"
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