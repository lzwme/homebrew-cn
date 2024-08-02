class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https:docs.chainloop.dev"
  url "https:github.comchainloop-devchainlooparchiverefstagsv0.95.3.tar.gz"
  sha256 "35c26277bcdc94c92bcd22349d7f3863a49334529565cc0eb567e2b1cace0294"
  license "Apache-2.0"
  head "https:github.comchainloop-devchainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3db91dd59bf6177709672dc8b08a8b1720d1891202e05732fb1cc8275101705a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6fe04f67db89c6c8eba50e36ade99acfc0c02de93390d4a1283c48957db6974b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3b4949f4507779316a94c9319d9ac6a642c5e0a6ab03afe7bda1f10e96477656"
    sha256 cellar: :any_skip_relocation, sonoma:         "aa92f070e958bc118ff9de1e6565a74417603c53f0b58d2ba64f53aae5f5463b"
    sha256 cellar: :any_skip_relocation, ventura:        "1b82099d1c07e9dec73642118a4136cc49e0702c037267ad094d835695b2422c"
    sha256 cellar: :any_skip_relocation, monterey:       "bab47172e1148eb98a2d4b8da81ed3bea8bace89ee6d3a285762960d69471ac5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d52f279c0c7508dfa8fc212f6d215346ecb6ad0411863cb25c825893a4c048e6"
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