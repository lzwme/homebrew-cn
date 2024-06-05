class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https:docs.chainloop.dev"
  url "https:github.comchainloop-devchainlooparchiverefstagsv0.90.1.tar.gz"
  sha256 "8444200ee47a66253e208ad8b91170b8546a7b93eeaf4b1605c7a1c34ac73fbd"
  license "Apache-2.0"
  head "https:github.comchainloop-devchainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2749dbefb1961ee199a010ddaaf640160c6cdd41de5f711c3170c23d6727fcde"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ccf18482e118884bcced11a4068abb6948fe3a6e828fe1b65a46c1be289eb6b1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4163b819cb430b491ebd758e7ccacfe8050f6a22f6bf792bb965f8f587ab2fb5"
    sha256 cellar: :any_skip_relocation, sonoma:         "fc6dd6eed1d1746c39181dc3957db4e91acd8c89ced132bea46f4e545dc0129a"
    sha256 cellar: :any_skip_relocation, ventura:        "fa86dbb6e78f34d6d79602d459aa04a1579da889a8fe9e1b3f68b16126a89de5"
    sha256 cellar: :any_skip_relocation, monterey:       "e76758ee4c2854eebc84ee3d1bf6200f2d03d3b667bf3f532a3715aa3297f01f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1b8ccf562dec055008f519eee46d3bf85c06bd1e238a804249bac3e0ef6c63a7"
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