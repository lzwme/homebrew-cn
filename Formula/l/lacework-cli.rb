class LaceworkCli < Formula
  desc "CLI for managing Lacework"
  homepage "https:docs.lacework.comcli"
  url "https:github.comlaceworkgo-sdk.git",
      tag:      "v2.2.0",
      revision: "80646d5596b2180e888fe708d20c704f51a4b2f2"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7f5e9b458738d0a6c6e7b7ace80bef3011fb967d92c3d24822d311045b85d70b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7f5e9b458738d0a6c6e7b7ace80bef3011fb967d92c3d24822d311045b85d70b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7f5e9b458738d0a6c6e7b7ace80bef3011fb967d92c3d24822d311045b85d70b"
    sha256 cellar: :any_skip_relocation, sonoma:        "9615ec345b2ad51e63f418a3f3592332699991581a3bb83981434d32681ac144"
    sha256 cellar: :any_skip_relocation, ventura:       "9615ec345b2ad51e63f418a3f3592332699991581a3bb83981434d32681ac144"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "380f5be0d8d47b794e7d6bc9ee09bdb7c7a166ec5b0508a9d4a09e65d1d8327e"
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