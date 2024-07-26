class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https:docs.chainloop.dev"
  url "https:github.comchainloop-devchainlooparchiverefstagsv0.94.3.tar.gz"
  sha256 "570be291d95d3b4aecb20913cdc574112b469963321f98dcd81a1bef180486f2"
  license "Apache-2.0"
  head "https:github.comchainloop-devchainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6e793e85de3ef1adf1503c75598bbe2d5af0b8d1e994e20d3b840e55de8addbe"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "817659e2176aef8bb60973cb67380b7be004e4492e6aa137d1c7a431838b3f77"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "97cb42ae84126c477be7d958833c8624d0aec397170b8999068b9d679ec1ec58"
    sha256 cellar: :any_skip_relocation, sonoma:         "3d3f0d010789e43c81404e8da5fa3800864aeeddac7a3eb5137af83109cf5add"
    sha256 cellar: :any_skip_relocation, ventura:        "0b70a70545c7ecf3a6a4b1fc501ffecbe6c79ce90881275bfc4582a609a4e9dd"
    sha256 cellar: :any_skip_relocation, monterey:       "453d29cd576e061916949ce79e278bde904d473b7af05a868f843e3d75e339a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3f5cf2360fb99bdbc6f86a237dfd25562bcf83885df9257f6cbf41cc11303b10"
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