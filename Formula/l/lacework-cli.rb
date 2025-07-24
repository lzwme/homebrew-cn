class LaceworkCli < Formula
  desc "CLI for managing Lacework"
  homepage "https://docs.lacework.com/cli"
  url "https://github.com/lacework/go-sdk.git",
      tag:      "v2.5.0",
      revision: "fd88dc3f9762ff3855488e3f263301173224ecde"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "61f86f2d1a861f1eb44d0111de2073c545a9d861dbeabbde0aaeb0e36762d955"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "61f86f2d1a861f1eb44d0111de2073c545a9d861dbeabbde0aaeb0e36762d955"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "61f86f2d1a861f1eb44d0111de2073c545a9d861dbeabbde0aaeb0e36762d955"
    sha256 cellar: :any_skip_relocation, sonoma:        "e2b34135b02221c19d27150ec78ab0c9ec31f375ce86d1189a160c9c2892d337"
    sha256 cellar: :any_skip_relocation, ventura:       "e2b34135b02221c19d27150ec78ab0c9ec31f375ce86d1189a160c9c2892d337"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "71ee634270670bc7ebbe5bdb7391fbdb3aeef8f43777248a271edc5553053411"
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

    generate_completions_from_executable(bin/"lacework", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lacework version")

    output = shell_output("#{bin}/lacework configure list 2>&1", 1)
    assert_match "ERROR unable to load profiles. No configuration file found.", output
  end
end