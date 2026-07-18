class LaceworkCli < Formula
  desc "CLI for managing Lacework"
  homepage "https://docs.lacework.com/cli"
  url "https://github.com/lacework/go-sdk.git",
      tag:      "v2.15.0",
      revision: "7c33a4b638f22e96afc70494124a5e75e0377038"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5a81b9918e7e07032a95d055d3de02f132d04b4a73a96a7debecd7a7ab4c82ba"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5a81b9918e7e07032a95d055d3de02f132d04b4a73a96a7debecd7a7ab4c82ba"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5a81b9918e7e07032a95d055d3de02f132d04b4a73a96a7debecd7a7ab4c82ba"
    sha256 cellar: :any_skip_relocation, sonoma:        "73cc33ecfa16ed3bb817059fdd256da629272f70a3273dbc7e8596a1f794ef17"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8b49b26504ad7fe8a797c7616f3c559d3eb49d8a923181ddb4179db725fafb88"
    sha256 cellar: :any,                 x86_64_linux:  "07247299e6bb7c986cb124322e421a5d541635b14e4b5b0e93bb837e9b2fe50a"
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