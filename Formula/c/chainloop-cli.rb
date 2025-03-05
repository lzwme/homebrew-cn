class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https:docs.chainloop.dev"
  url "https:github.comchainloop-devchainlooparchiverefstagsv0.177.0.tar.gz"
  sha256 "2cbe5adee57e25131901de5611f1beafc6753810c4b1ac3e4fd5b77cfb7f4e73"
  license "Apache-2.0"
  head "https:github.comchainloop-devchainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fc6711ee21771ecb3d73ba29e5d716eeeb228878cd70fa53a81c365e8f23cfff"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fc6711ee21771ecb3d73ba29e5d716eeeb228878cd70fa53a81c365e8f23cfff"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fc6711ee21771ecb3d73ba29e5d716eeeb228878cd70fa53a81c365e8f23cfff"
    sha256 cellar: :any_skip_relocation, sonoma:        "db913d804b0b120a316824e1eae747a8119bf858746d22674ef42235f89fc2fb"
    sha256 cellar: :any_skip_relocation, ventura:       "acdfe62298fde3989804314e0c1abbea36405d1096212a6e0607aefff6c7b479"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "58778ed7aef5b11d126f8f77cd7b290b6ce424c3bac0856011ee4ac58dfed2cc"
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