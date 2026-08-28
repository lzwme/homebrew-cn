class LaceworkCli < Formula
  desc "CLI for managing Lacework"
  homepage "https://github.com/lacework/go-sdk"
  url "https://github.com/lacework/go-sdk.git",
      tag:      "v2.16.0",
      revision: "be74ad1d3b93cb5e59a5f672cdaf2b7e9602992f"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c4cb48d1711f3c1963e13540f283c0a5762774f7350acfb8ad7f430b0e9a737b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c4cb48d1711f3c1963e13540f283c0a5762774f7350acfb8ad7f430b0e9a737b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c4cb48d1711f3c1963e13540f283c0a5762774f7350acfb8ad7f430b0e9a737b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "335b11001cec722d21d8ad69c0d79b2957c947f5a2ffbf5e6fcb64ef7f7c3870"
    sha256 cellar: :any,                 x86_64_linux:  "bea676dfc155d020ee5639810c7adb46e5f7a3828cd7070cc8ef30470dbc00bb"
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