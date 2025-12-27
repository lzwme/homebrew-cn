class LaceworkCli < Formula
  desc "CLI for managing Lacework"
  homepage "https://docs.lacework.com/cli"
  url "https://github.com/lacework/go-sdk.git",
      tag:      "v2.8.4",
      revision: "edf92c488cac5431929aa5d5474347d17842ff52"
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
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ef5b0d4677650dbf9141ad8f134f605fb28031b898ba3a7b06d5ccfa42c988ac"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ef5b0d4677650dbf9141ad8f134f605fb28031b898ba3a7b06d5ccfa42c988ac"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ef5b0d4677650dbf9141ad8f134f605fb28031b898ba3a7b06d5ccfa42c988ac"
    sha256 cellar: :any_skip_relocation, sonoma:        "5e63961eeb8daaf6e69abb1a4f41d470c833f2de72febce61bc0c2c5020abda0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "82a76a1ef59c8b66eb18aca312a11f0f82f7c8a653a29503729d61988cc6e3ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f68a6ce34e9ca7ef6f7d636d09eea6afe7334b9d3d300a3af510d27817161aa7"
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