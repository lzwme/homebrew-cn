class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https:docs.chainloop.dev"
  url "https:github.comchainloop-devchainlooparchiverefstagsv0.92.6.tar.gz"
  sha256 "dddc73c0fdefddfd3f9acc5f74e547022c76293b0bddab8d241b7c32083899c5"
  license "Apache-2.0"
  head "https:github.comchainloop-devchainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "09e7cdd04cc14daf022de69fb19b634c1790f16900179c7544f7345dc0f2faaa"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c1e2fa5b394a45c0e5152c61e7f04514b7311fd0fcfdf24c9f64f0c73091edbc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fc5220abd8afa2c67051d5bd6eaf1ad72963ee97479b3119c9cfda61b779f85e"
    sha256 cellar: :any_skip_relocation, sonoma:         "616cb8b057854434819279ac72639a9b58dafd3abf72cddb079fcaf8b3e1605c"
    sha256 cellar: :any_skip_relocation, ventura:        "3a4beebe85fba1e41a01906179eae93f71e21c92931f66c73ec4106a84d61a40"
    sha256 cellar: :any_skip_relocation, monterey:       "c45e58a003472737f36ea3e94884381b53a947d16b6c666c33921b401ef0af9c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "75012c36bbf8fa4f4449be02c5e4f3794967e6c8fd3161dbbdeaf6680e41b571"
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