class LaceworkCli < Formula
  desc "CLI for managing Lacework"
  homepage "https:docs.lacework.comcli"
  url "https:github.comlaceworkgo-sdk.git",
      tag:      "v2.3.0",
      revision: "dbd13dc3e3afdbca24851462d3e28c4d3ee60d55"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d660889139b5b38f45ba013d6003dce30d14732eeee5428a1f350423d9344d2a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d660889139b5b38f45ba013d6003dce30d14732eeee5428a1f350423d9344d2a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d660889139b5b38f45ba013d6003dce30d14732eeee5428a1f350423d9344d2a"
    sha256 cellar: :any_skip_relocation, sonoma:        "07d843aa9e2fee77ffdb66cd6f7e16fb749c278fa608a697631754cdc6adbb3f"
    sha256 cellar: :any_skip_relocation, ventura:       "07d843aa9e2fee77ffdb66cd6f7e16fb749c278fa608a697631754cdc6adbb3f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d29f439eb25d79cfe23c600b07800fef2981d754a0f04f4b97461f4e6bc8fe7d"
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