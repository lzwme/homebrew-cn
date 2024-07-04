class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https:docs.chainloop.dev"
  url "https:github.comchainloop-devchainlooparchiverefstagsv0.93.3.tar.gz"
  sha256 "eb8db17de0caa8b2d35662419f825d2b7a85809ff57f6aefe098616f616d5755"
  license "Apache-2.0"
  head "https:github.comchainloop-devchainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2512829e9a64a2237b7621cbf0d6f41b6e0b3bd31e0a8292cc7d3fc74311851b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d7824e10174e7210ec91cb4645025191828b310071db93ec5ea12a590e571395"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "556a476425b86e623413786b954e9b62503a91c2a90d3bd437df74e60882a05c"
    sha256 cellar: :any_skip_relocation, sonoma:         "803e802abece250980ea7e4bf932a474996e078527ddd109c85941d9d7f29ec6"
    sha256 cellar: :any_skip_relocation, ventura:        "8979e9ac60d74dbd0371baee4a3aaebac7131b7892c7db16d096a2ee46bc77b4"
    sha256 cellar: :any_skip_relocation, monterey:       "73ab4138a5dd66cc5ee456e757c27aef3ffd3fa1b155628c4dd19213b196e13a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "76f032cb3f4cdd12a172d64ea77a6b8724bbff7b4649afb8185970f46b6e0c62"
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