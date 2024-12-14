class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https:docs.chainloop.dev"
  url "https:github.comchainloop-devchainlooparchiverefstagsv0.139.0.tar.gz"
  sha256 "4c8b9b38bb1c8e0dc7834465cf1d42e3b2acf8ab03d98eac2dfc2a581cf8a3fa"
  license "Apache-2.0"
  head "https:github.comchainloop-devchainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f1b3299362560cc809880b189052d1a2cad1f2594f976b84f60c2366b333f0f6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f1b3299362560cc809880b189052d1a2cad1f2594f976b84f60c2366b333f0f6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f1b3299362560cc809880b189052d1a2cad1f2594f976b84f60c2366b333f0f6"
    sha256 cellar: :any_skip_relocation, sonoma:        "8c16588c3eef6aac18ca39ee9fdda29378a3df71e03850aa5ae14d8ad560e89a"
    sha256 cellar: :any_skip_relocation, ventura:       "2e8d5f91bd6e0b50593387d1cd31a4a5ed796d90c2e335e6016af402be7b3ef6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "feddca290973cfa7b965927ff9f1f66f1332e230ee86e7aec5bd360284e310c8"
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