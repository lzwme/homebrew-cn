class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https:docs.chainloop.dev"
  url "https:github.comchainloop-devchainlooparchiverefstagsv0.93.6.tar.gz"
  sha256 "bf6ae5d17bfc4e812627ffec8d85ad2826402ff414ba68b4af87a56ed0463e83"
  license "Apache-2.0"
  head "https:github.comchainloop-devchainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a8013d539dc4c8e756ef2b60da7d046bdd5c5cf232543be2672630a481e794a8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f50271d97078d4ca5cb37b57d0c437b1744c7fb49eb6ed37c727527a2064cf34"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8c6f7fcce5ee551cbab88468c33d91bf740d51c0185100338ccad10486525994"
    sha256 cellar: :any_skip_relocation, sonoma:         "cae5ba4ebdbb7aa04789032b9848add1c9e492bce75a6b530a31a8ec07d79970"
    sha256 cellar: :any_skip_relocation, ventura:        "9f7fd6a65103a6d69b8807dc30dea9411e9393e7ee2da3482ef7d347e621e54d"
    sha256 cellar: :any_skip_relocation, monterey:       "dbeaa88e89bc037953b9ff8f017f6c925a985b6467dcf76b96649b263efcc34c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ce2f14b5cca0a4b44aeda78456a961cae12a2b7df3c9b5b468b5f775bcd85441"
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