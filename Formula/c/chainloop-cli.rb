class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https:docs.chainloop.dev"
  url "https:github.comchainloop-devchainlooparchiverefstagsv0.153.0.tar.gz"
  sha256 "ec4ea5dc12a199a1738e06388648e287469da088df64889095f95033b5e2c12a"
  license "Apache-2.0"
  head "https:github.comchainloop-devchainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "64fc857ea92d83e07347958eef25f1df45a33a71eeaaff33da9c2985f5574050"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "64fc857ea92d83e07347958eef25f1df45a33a71eeaaff33da9c2985f5574050"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "64fc857ea92d83e07347958eef25f1df45a33a71eeaaff33da9c2985f5574050"
    sha256 cellar: :any_skip_relocation, sonoma:        "e0b56756280d3c6e191aa426b98bb18212630596beac6ee98da72fdd52acdeac"
    sha256 cellar: :any_skip_relocation, ventura:       "9bafdf11ef51072f80aa56668d57bd2c9f1fc1f41e9b49bec70bdda9beb29f55"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ae7b3a6cbbce8ab0e32828b25834b8faf3b7b636654366ab79d5cb8a5586199c"
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