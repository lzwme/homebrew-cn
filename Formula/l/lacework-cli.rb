class LaceworkCli < Formula
  desc "CLI for managing Lacework"
  homepage "https:docs.lacework.comcli"
  url "https:github.comlaceworkgo-sdk.git",
      tag:      "v2.1.3",
      revision: "944791cc962c1eb3f3bd48a1ec8123d882148841"
  license "Apache-2.0"
  head "https:github.comlaceworkgo-sdk.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a1084ed3128b8eda03e5eec56c1dcc35645d3e74cf33ca52dda382bd3becbc54"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a1084ed3128b8eda03e5eec56c1dcc35645d3e74cf33ca52dda382bd3becbc54"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a1084ed3128b8eda03e5eec56c1dcc35645d3e74cf33ca52dda382bd3becbc54"
    sha256 cellar: :any_skip_relocation, sonoma:        "0a5b343a0945da1ff8c4aceefa163a5de60e97eed66f4c08c7731b87935dff85"
    sha256 cellar: :any_skip_relocation, ventura:       "0a5b343a0945da1ff8c4aceefa163a5de60e97eed66f4c08c7731b87935dff85"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3e857e211fce4fa9ad948067f6263bae667f7611b00c888d21e49afc77b1c4f2"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comlaceworkgo-sdkv2clicmd.Version=#{version}
      -X github.comlaceworkgo-sdkv2clicmd.GitSHA=#{Utils.git_head}
      -X github.comlaceworkgo-sdkv2clicmd.HoneyDataset=lacework-cli-prod
      -X github.comlaceworkgo-sdkv2clicmd.BuildTime=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(output: bin"lacework", ldflags:), ".cli"

    generate_completions_from_executable(bin"lacework", "completion", base_name: "lacework")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}lacework version")

    output = shell_output("#{bin}lacework configure list 2>&1", 1)
    assert_match "ERROR unable to load profiles. No configuration file found.", output
  end
end