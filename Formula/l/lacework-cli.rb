class LaceworkCli < Formula
  desc "CLI for managing Lacework"
  homepage "https:docs.lacework.comcli"
  url "https:github.comlaceworkgo-sdk.git",
      tag:      "v2.1.2",
      revision: "15c6b21b6f22ac366e469f13ce690d5f2ccd628d"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f1342de716428365bf04c6552da8d921cf7e2fe61e2cd443a6a0e6af145f2fe8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f1342de716428365bf04c6552da8d921cf7e2fe61e2cd443a6a0e6af145f2fe8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f1342de716428365bf04c6552da8d921cf7e2fe61e2cd443a6a0e6af145f2fe8"
    sha256 cellar: :any_skip_relocation, sonoma:        "494fdc397745e6a6ce1d34b41e71a885637d3ba0eec9bd025ae03210edaac38d"
    sha256 cellar: :any_skip_relocation, ventura:       "494fdc397745e6a6ce1d34b41e71a885637d3ba0eec9bd025ae03210edaac38d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5fce4f3c1066566298dab656e638b9c154e29dc36bb179666219f3d8ac148260"
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