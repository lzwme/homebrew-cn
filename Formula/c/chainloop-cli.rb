class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https:docs.chainloop.dev"
  url "https:github.comchainloop-devchainlooparchiverefstagsv0.138.0.tar.gz"
  sha256 "55c027afe5ae90588f4aede873e2e3c9f86763dd40bc18f890054452733f44f7"
  license "Apache-2.0"
  head "https:github.comchainloop-devchainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9dbe40164b374be5a1ad182dfea23dcbd79cf732f47ef1ddc22855e292d965b6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9dbe40164b374be5a1ad182dfea23dcbd79cf732f47ef1ddc22855e292d965b6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9dbe40164b374be5a1ad182dfea23dcbd79cf732f47ef1ddc22855e292d965b6"
    sha256 cellar: :any_skip_relocation, sonoma:        "0325bd2021c60375fee7d9825d26e620f171498f6679a37f681f146b4c5dfc77"
    sha256 cellar: :any_skip_relocation, ventura:       "bcaa0b469e6482846456cca42186b9265c89ae1f63b80774d140df592534cfd6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "617356e77f6d8075cbb2769d5ac0ee68277b9599cdea089afc165a68593026bf"
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