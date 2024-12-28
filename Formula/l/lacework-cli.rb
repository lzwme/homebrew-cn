class LaceworkCli < Formula
  desc "CLI for managing Lacework"
  homepage "https:docs.lacework.comcli"
  url "https:github.comlaceworkgo-sdk.git",
      tag:      "v2.1.4",
      revision: "e7e19c2b38a95c15d277468ab75e5b305451e18b"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1cd3477e05510e8ef19a6359e13c341c7e398b93d8d960b19b2fb52e85680b6b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1cd3477e05510e8ef19a6359e13c341c7e398b93d8d960b19b2fb52e85680b6b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1cd3477e05510e8ef19a6359e13c341c7e398b93d8d960b19b2fb52e85680b6b"
    sha256 cellar: :any_skip_relocation, sonoma:        "7a3c49529dc73131e10918b30137b7bfac3504129d51e2c08c8bec3c51eb1821"
    sha256 cellar: :any_skip_relocation, ventura:       "7a3c49529dc73131e10918b30137b7bfac3504129d51e2c08c8bec3c51eb1821"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c6580fedcc4bc1eadf37754a4c390a935e4315d4f797f04863e09f679257be84"
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

    generate_completions_from_executable(bin"lacework", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}lacework version")

    output = shell_output("#{bin}lacework configure list 2>&1", 1)
    assert_match "ERROR unable to load profiles. No configuration file found.", output
  end
end