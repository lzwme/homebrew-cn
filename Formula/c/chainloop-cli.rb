class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https:docs.chainloop.dev"
  url "https:github.comchainloop-devchainlooparchiverefstagsv0.91.8.tar.gz"
  sha256 "4e837dce2465e5da6857947aff81b64327131a75153a85c56b49de22a013a7f8"
  license "Apache-2.0"
  head "https:github.comchainloop-devchainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b916c63678591cf4fbda94dbec0049af767ed3baf7d3484702217c2ac7c43fc3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0f1a13635f6df78776c79e2f78b713404d7625b5285ffb36110e6db76a0e24ba"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3304f0d42fd5485014c6ffe30502611c3dd31d0bae8dcb70ef753b65b37cee41"
    sha256 cellar: :any_skip_relocation, sonoma:         "1769f5e37e11e838dd8be1909c2406be64f29739a1bd2fc1eda31f28d01abd4a"
    sha256 cellar: :any_skip_relocation, ventura:        "5d3f382802362ca197a60c4280a797476e6e894bc675f6268df5a106179f66f7"
    sha256 cellar: :any_skip_relocation, monterey:       "f0cb59c1e64b9ccd9065ee7e9a4e125adfdf34ccf83a7e9961384be2918a5875"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "578a51f3f1bc3a6fbfa0a1c6bbc5bd92a02c21a6c1e362d7803e016e46729c7e"
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