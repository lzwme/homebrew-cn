class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https:docs.chainloop.dev"
  url "https:github.comchainloop-devchainlooparchiverefstagsv1.18.0.tar.gz"
  sha256 "dce6c9d3c40be97561feb48d339d9f49011300f75e0eb7cb412ed7b8ce5f5419"
  license "Apache-2.0"
  head "https:github.comchainloop-devchainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a7a3ca265499bb6ef41c1a49fc440ac2ff1c36e88a852372f6d3b214a670444f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "de49437332d4b140dfbe19979061543b3bbb543c42cf48714c49a985b87d5841"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c59a1cf5dea184b22483624addf1e4da9d8b56e213809eb6157fe2a3db9ec6fe"
    sha256 cellar: :any_skip_relocation, sonoma:        "a2f2347d81d51aeb71f41ba2368942c03dd978917e466b9a2bcbfa2416d8eca9"
    sha256 cellar: :any_skip_relocation, ventura:       "4d0e82e63198326aa8b43593edd469f9570c050d9b0bb336b0f2b4374de8d9c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e1646d3575ed9f137e13741a6e4499496f1389ff1b15d378e4f16defd8d5b5c2"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comchainloop-devchainloopappclicmd.Version=#{version}
    ]

    system "go", "build", *std_go_args(ldflags:, output: bin"chainloop"), ".appcli"

    generate_completions_from_executable(bin"chainloop", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}chainloop version 2>&1")

    output = shell_output("#{bin}chainloop artifact download 2>&1", 1)
    assert_match "authentication required, please run \"chainloop auth login\"", output
  end
end