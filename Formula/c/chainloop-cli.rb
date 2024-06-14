class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https:docs.chainloop.dev"
  url "https:github.comchainloop-devchainlooparchiverefstagsv0.91.5.tar.gz"
  sha256 "7b5e7bce09564513f78655fcbb8a03c1647fff2e3fd8fd5e4c0cdc27053c711b"
  license "Apache-2.0"
  head "https:github.comchainloop-devchainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0fbea0eb16f63fdec068a255e4fef006c0a62c2e6dfeb78806a6d4836b7319a5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cadfdd2ca3618690bd8d77d10a0808f6ce06ab95e839b95a4128ed0319e82c37"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7f060410c64a26ae530c31d6a495b3ecf4f745f306e706648f1293da5612a763"
    sha256 cellar: :any_skip_relocation, sonoma:         "130de110399f2a33318d5d2a8164937c0ceb46b47272aa2ad165b6287e8a7e49"
    sha256 cellar: :any_skip_relocation, ventura:        "aaa66815b3a6ffed8e93e28bcaf867899c0832fe94c2a0e2bcc5974b3837345f"
    sha256 cellar: :any_skip_relocation, monterey:       "19f66110c9a39f336ad6d618abc49913983943af42063cdcbe781c5a8efae845"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0c1fcbd49f191bfbe2867d3d9042d2c99c25450cf0ded056bde12f3879308c22"
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