class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https:docs.chainloop.dev"
  url "https:github.comchainloop-devchainlooparchiverefstagsv1.4.2.tar.gz"
  sha256 "bbb76473aa407c2fece4cd6cccbab2dec25a3e2cc1fe9c4e28251b6c8b107bf0"
  license "Apache-2.0"
  head "https:github.comchainloop-devchainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0fa6f4e269b9f5d0be3fc8f010630beb83fb81a3871d3dfd4c49c625d8a11b9c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9a5db5fe4922a9d5e0382227211d02e545baa9b7bdbcdb322205716d316733e0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e6d45cc4467addd898cdbbef027e4582ca25221b82bb37cf3d866afcebbc05a8"
    sha256 cellar: :any_skip_relocation, sonoma:        "e8ccbc2d3c8c909f8d092b5272daab344859cfb067936c861dbaf33dddf21a8a"
    sha256 cellar: :any_skip_relocation, ventura:       "d7d09156a534b6cb3e842ed075a86553216d2ba923156c371a6d159b923ccb6d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "259297a191d40b7599c38f9bc8b00915621c16c6a5363823d9065661ce8b9f68"
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