class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https:docs.chainloop.dev"
  url "https:github.comchainloop-devchainlooparchiverefstagsv0.185.0.tar.gz"
  sha256 "09aeafdbfd042bbd16da4e0194e07d28aea6bf2f2089f58e574fc3cdf7d156b5"
  license "Apache-2.0"
  head "https:github.comchainloop-devchainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f4ad976ebaf01c4caf0870899ac123a7c7279c4ad4d1604a03dff99fb981d922"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f4ad976ebaf01c4caf0870899ac123a7c7279c4ad4d1604a03dff99fb981d922"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f4ad976ebaf01c4caf0870899ac123a7c7279c4ad4d1604a03dff99fb981d922"
    sha256 cellar: :any_skip_relocation, sonoma:        "86594af90e5beff82f36a98f49e5d026f3ccff4e784fb1b986ec3228597c65f8"
    sha256 cellar: :any_skip_relocation, ventura:       "03e7e3faecfb74d502b79f1f410a7c748967557bd78eb629fbd6b6826c50bc84"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a5a66c805fb673a6771df1037da94592e6ebce19b234cdd577f37931afdefaa4"
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