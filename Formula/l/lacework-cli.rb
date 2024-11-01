class LaceworkCli < Formula
  desc "CLI for managing Lacework"
  homepage "https:docs.lacework.comcli"
  url "https:github.comlaceworkgo-sdk.git",
      tag:      "v2.1.1",
      revision: "22ae1ee80d118193c12040bc9c3e6d205e427c5e"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b3a4e03dae7e0c9e1044d8cfd4ae36a342009b42f55785924d858bd25888f260"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b3a4e03dae7e0c9e1044d8cfd4ae36a342009b42f55785924d858bd25888f260"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b3a4e03dae7e0c9e1044d8cfd4ae36a342009b42f55785924d858bd25888f260"
    sha256 cellar: :any_skip_relocation, sonoma:        "5b9cf8172964ba4e1b2f1e01a2ff46d0942408c7090753b580fb978a087ccf44"
    sha256 cellar: :any_skip_relocation, ventura:       "5b9cf8172964ba4e1b2f1e01a2ff46d0942408c7090753b580fb978a087ccf44"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1bb0af316d17b8f76f492d4200a34955ed48695df91fb07fa5d20bc440965485"
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