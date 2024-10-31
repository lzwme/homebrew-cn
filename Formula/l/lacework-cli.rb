class LaceworkCli < Formula
  desc "CLI for managing Lacework"
  homepage "https:docs.lacework.comcli"
  url "https:github.comlaceworkgo-sdk.git",
      tag:      "v2.1.0",
      revision: "505540c7dc79e8ff01219bdac8eb6073f0a70259"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aa57e8eae429620b9848cb8ec85bc3fab5227738b163719714d1bff5f90adeef"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aa57e8eae429620b9848cb8ec85bc3fab5227738b163719714d1bff5f90adeef"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "aa57e8eae429620b9848cb8ec85bc3fab5227738b163719714d1bff5f90adeef"
    sha256 cellar: :any_skip_relocation, sonoma:        "85a85e7df0131550ffc6d546846577ec778634fcd7377e85ff494ca289087c1c"
    sha256 cellar: :any_skip_relocation, ventura:       "85a85e7df0131550ffc6d546846577ec778634fcd7377e85ff494ca289087c1c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1758a0a6e067bece368ba89d0b6fd4930fcf9a89e7eb2346324a608cb193e9f4"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comlaceworkgo-sdkclicmd.Version=#{version}
      -X github.comlaceworkgo-sdkclicmd.GitSHA=#{Utils.git_head}
      -X github.comlaceworkgo-sdkclicmd.HoneyDataset=lacework-cli-prod
      -X github.comlaceworkgo-sdkclicmd.BuildTime=#{time.iso8601}
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