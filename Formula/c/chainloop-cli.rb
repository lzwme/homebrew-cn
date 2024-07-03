class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https:docs.chainloop.dev"
  url "https:github.comchainloop-devchainlooparchiverefstagsv0.93.2.tar.gz"
  sha256 "4ef7dfe7268f2f4879e414a64ce6bcab80cc2605c46ab02210f8f0cb6a64123a"
  license "Apache-2.0"
  head "https:github.comchainloop-devchainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "68e009ea70b42efebe713ebf8b6f270d34e22714b3016335744fb3001945ecaa"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0cc8dcdb99aae3617880ae6ea4e84eddadd3eda686333f203f4b192739a5e1a5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "28d7264b93ef9d94f56e605a8d61619218597eafe40c7ad995ec94adc021a3c4"
    sha256 cellar: :any_skip_relocation, sonoma:         "cf05885ee2007945010ef4f34022445d194c72deb6dd159207fb80403c2ea038"
    sha256 cellar: :any_skip_relocation, ventura:        "98ef9d0f3e4f41d3d63017d374897272e87b51601872e4ec5f25dea79c3c593c"
    sha256 cellar: :any_skip_relocation, monterey:       "78e97230632c9cd7c6ef505b2e290d9a90c5fb63498ba8a89dd0b4f36c04ff3c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2a0abe6a4679459319252cd0c24ab1793155e5e955c03941b26e661fb415471b"
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