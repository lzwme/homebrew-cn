class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https:docs.chainloop.dev"
  url "https:github.comchainloop-devchainlooparchiverefstagsv0.81.1.tar.gz"
  sha256 "805dd3d18df81297cfe8e44c24097b8fa85e12236d34ecc4780a65ac8a197492"
  license "Apache-2.0"
  head "https:github.comchainloop-devchainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4798cb1f45668eaa25ff7673a0c0b7b94c4db719e5030ac5106a869aaaa2f8e1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "db45780d42d407a40fdcd6b0026c69b1d792e546ab439daecee8fab628cd9ed2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7eb59e7253d151a03c1a95e1cce52c765bd09f5d0ab13cecfe7eac35a1f2302f"
    sha256 cellar: :any_skip_relocation, sonoma:         "b6710ab065c30eb5642cd71893e95fc867713ac0bb1231afb559b0cbbd3dbdd4"
    sha256 cellar: :any_skip_relocation, ventura:        "218b789ffa366918efd25b1dc3a1e353025080a168865660e505488e7af6959d"
    sha256 cellar: :any_skip_relocation, monterey:       "626cb506d976d758ecfa57279c3a37aafd6d7d28b09e15eabb1c25b55b93aaf3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8861457596f54270f15cca5d3f4099e1a178d402a07fbab99c84c591b168d4aa"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comchainloop-devchainloopappclicmd.Version=#{version}
    ]

    system "go", "build", *std_go_args(output: bin"chainloop", ldflags:), ".appcli"

    generate_completions_from_executable(bin"chainloop", "completion", base_name: "chainloop")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}chainloop version 2>&1")

    output = shell_output("#{bin}chainloop artifact download 2>&1", 1)
    assert_match "authentication required, please run \"chainloop auth login\"", output
  end
end