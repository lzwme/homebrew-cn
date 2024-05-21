class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https:docs.chainloop.dev"
  url "https:github.comchainloop-devchainlooparchiverefstagsv0.88.1.tar.gz"
  sha256 "4cb3d44ec1d81e86ba5b613258fc1a50d24d504685e230f1f53e8dbcdd08da79"
  license "Apache-2.0"
  head "https:github.comchainloop-devchainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ffa992e8905ff31e88559f93b6e6f53c197114cfdd37abbd119d82df223b651c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "04a3acc0cea6cb453e2b4bc2d651b48ca282a5acac7c9932d2881482e3b6a7c8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "65c698851936524ebe9e48af5470137e341586f4ef16aad0d3f7c4c702dee356"
    sha256 cellar: :any_skip_relocation, sonoma:         "770d35146813c65038aad1e14945729ea6afd024f1e73d6d335327afc17ea2c1"
    sha256 cellar: :any_skip_relocation, ventura:        "ce9f95f2ba53549037315461562d3a9eb96100ad1e4c8da102994aacbbb9016d"
    sha256 cellar: :any_skip_relocation, monterey:       "6915da31aa07df95ea7b18597adea32f35ad7db920ced0407ce6a4711381507b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4a246cce43ab02cd7e80a307c5976af3a7ad41fdaf96ddc14286aa85a11170b8"
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