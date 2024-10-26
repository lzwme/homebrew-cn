class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https:docs.chainloop.dev"
  url "https:github.comchainloop-devchainlooparchiverefstagsv0.97.4.tar.gz"
  sha256 "792e597e83b279e2ca5e3c17cbecfa549103ea455947acc561f3ce211d1cb3a4"
  license "Apache-2.0"
  head "https:github.comchainloop-devchainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e8073da5433a4612d7c077af4bc589577ed29a00e44ec6998136110aecec5f63"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e8073da5433a4612d7c077af4bc589577ed29a00e44ec6998136110aecec5f63"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e8073da5433a4612d7c077af4bc589577ed29a00e44ec6998136110aecec5f63"
    sha256 cellar: :any_skip_relocation, sonoma:        "eb67f484a9b9eaf8ccb342916c5204ff3fc7d3496475c3a136fcc8b03d13dc11"
    sha256 cellar: :any_skip_relocation, ventura:       "1036a705f8bd00e1e347b1d7e341b90704660afaf1112f4ef65a027adba3fd02"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3e25b2e633705326b8a400978568b2feb88cb06a4c32ed2845eb43d2534a7996"
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