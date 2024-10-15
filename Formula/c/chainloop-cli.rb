class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https:docs.chainloop.dev"
  url "https:github.comchainloop-devchainlooparchiverefstagsv0.96.18.tar.gz"
  sha256 "fa21ef218ad6ac8f5575bec5fe81af3a7d68e1bbb6047307fef2d067325b0cc4"
  license "Apache-2.0"
  head "https:github.comchainloop-devchainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "80ad9861bacecf0153bf4ebd8ba126864815ea021d281b9c86f55bcd5d35a8cf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "80ad9861bacecf0153bf4ebd8ba126864815ea021d281b9c86f55bcd5d35a8cf"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "80ad9861bacecf0153bf4ebd8ba126864815ea021d281b9c86f55bcd5d35a8cf"
    sha256 cellar: :any_skip_relocation, sonoma:        "d81ad1bf60f2f753b579f8cb3ca28a0ebd9e87705ae380b231291f91d3391c69"
    sha256 cellar: :any_skip_relocation, ventura:       "8db79f719ae1b82b86ad4646363a870b0af574a655f3fbb31849682a3729788d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dc9c400a556d753286cf3c60397ac35afa701f30b33d268a10f3995f090dc6ad"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comchainloop-devchainloopappclicmd.Version=#{version}
    ]

    system "go", "build", *std_go_args(ldflags:, output: bin"chainloop"), ".appcli"

    generate_completions_from_executable(bin"chainloop", "completion", base_name: "chainloop")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}chainloop version 2>&1")

    output = shell_output("#{bin}chainloop artifact download 2>&1", 1)
    assert_match "authentication required, please run \"chainloop auth login\"", output
  end
end