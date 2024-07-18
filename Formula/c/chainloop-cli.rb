class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https:docs.chainloop.dev"
  url "https:github.comchainloop-devchainlooparchiverefstagsv0.93.8.tar.gz"
  sha256 "b349d935c2926045e6c2366fcc76b3ca46ccbba62cf4ecfe422f96cdb4792d7b"
  license "Apache-2.0"
  head "https:github.comchainloop-devchainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "36d805218320fd7c952c8c3b0978bd083116010261aca1d8b3d0375cf2db6e94"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fdd3241d2e4f15f5e5282840f8e27b32d9b7455a61fa24dacdf398af5daedcba"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5a7734aa3be845b1d76645a5198a93080f8e71662059e195a6c13bb7d485e84c"
    sha256 cellar: :any_skip_relocation, sonoma:         "1372f26c7a7c063e629e3077e223effe5c95a69c9f3511c0b875bd1a1bb9e0de"
    sha256 cellar: :any_skip_relocation, ventura:        "8076e74e683b8623a396ae5c3ae47b22c1ce1d841ac8e0ceefc659c19708c385"
    sha256 cellar: :any_skip_relocation, monterey:       "93f7bcedde3516b5f343ca54b32500eb912e2bc3b6fc4db7ea3cb49d56617320"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "744a3fe7602dd3fcb26d4400b9a523fec1e00f980b927f7a95dc647f838f7f4e"
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