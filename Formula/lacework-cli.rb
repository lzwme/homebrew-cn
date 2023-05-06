class LaceworkCli < Formula
  desc "CLI for managing Lacework"
  homepage "https://docs.lacework.com/cli"
  url "https://github.com/lacework/go-sdk.git",
      tag:      "v1.18.2",
      revision: "15df646fb2ed0270c40b4701038f8c118dbb8418"
  license "Apache-2.0"
  head "https://github.com/lacework/go-sdk.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a238f144303d92be143b104e65dd27752a50210af41b2e4668f434c888713695"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dbee788d3828d31053aea243eac653ab1ad139f38eb2dd7d356a9e10e0095e74"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a98fc1a944a0d6988c37f6d2e82a1a07c3e33f7fa26b6b9972d33c34011d88ab"
    sha256 cellar: :any_skip_relocation, ventura:        "7f55afb86bbf7a125e8d517f6680b3e2c5e602227a7653f0c96b9c2cf19008a0"
    sha256 cellar: :any_skip_relocation, monterey:       "86b8c2be2b938fa28425a34d8bc9b502904d2e4434c15cf2ccb7320dc6107235"
    sha256 cellar: :any_skip_relocation, big_sur:        "19fe7bf30aba8fedc467ef9256d5f14502e88ec423d22076774e502c792360b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b89fdf845f6891fc65745f82b938a7cb028b38593af2c82ba6273ede0e52cadd"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/lacework/go-sdk/cli/cmd.Version=#{version}
      -X github.com/lacework/go-sdk/cli/cmd.GitSHA=#{Utils.git_head}
      -X github.com/lacework/go-sdk/cli/cmd.BuildTime=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(output: bin/"lacework", ldflags: ldflags), "./cli"

    generate_completions_from_executable(bin/"lacework", "completion", base_name: "lacework")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lacework version")

    output = shell_output("#{bin}/lacework configure list 2>&1", 1)
    assert_match "ERROR unable to load profiles. No configuration file found.", output
  end
end