class LaceworkCli < Formula
  desc "CLI for managing Lacework"
  homepage "https://docs.lacework.com/cli"
  url "https://github.com/lacework/go-sdk.git",
      tag:      "v1.13.3",
      revision: "ab00f35f0f718ea87dfe077ae1b06286b4dfce7f"
  license "Apache-2.0"
  head "https://github.com/lacework/go-sdk.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bae5a834a9b78ebeea4275d3ff1fe717b12def8db55703a1ffc2ea9023ff9a18"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a224b6723b2e2e3d5880df8871f39d6a27e6fab39c50a2fbb63230ef2d19c027"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "30d7de8fe1c12aa6735f769ea8303fab990216678d2366a442c9127f81e25a75"
    sha256 cellar: :any_skip_relocation, ventura:        "aa540d17243560b57b44e5c8a5892d5e822f60a2b27ce2481e4dad1ebd28bd03"
    sha256 cellar: :any_skip_relocation, monterey:       "3db37198274ece8d87fa727ff579773dc78bdcb72f0562cb0d692887dd8f0ff7"
    sha256 cellar: :any_skip_relocation, big_sur:        "223b059562fff3b1eb6420100b4d630aa31a8ad93bc1e4695c6cb733a4783d59"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "370bb04ad7f8316f990807f8471445b6384ce90fe852800dd0efb6f0f5e85204"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/lacework/go-sdk/cli/cmd.Version=#{version}
      -X github.com/lacework/go-sdk/cli/cmd.GitSHA=#{Utils.git_head}
      -X github.com/lacework/go-sdk/cli/cmd.BuildTime=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(output: bin/"lacework", ldflags: ldflags), "./cli"

    generate_completions_from_executable(bin/"lacework", "completion", base_name: "lacework")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lacework version")

    output = shell_output("#{bin}/lacework configure list 2>&1", 1)
    assert_match "ERROR unable to load profiles. No configuration file found.", output
  end
end