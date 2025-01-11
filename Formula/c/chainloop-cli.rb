class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https:docs.chainloop.dev"
  url "https:github.comchainloop-devchainlooparchiverefstagsv0.151.0.tar.gz"
  sha256 "8b1b849f377dcd33921d0347657b3870bba9ef999159bbb1aa0daf1f8873b8a7"
  license "Apache-2.0"
  head "https:github.comchainloop-devchainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a66df32d21f77ef9399391c3b53a1a3e4b6d937cca70b99483e5a19ad787fe5a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a66df32d21f77ef9399391c3b53a1a3e4b6d937cca70b99483e5a19ad787fe5a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a66df32d21f77ef9399391c3b53a1a3e4b6d937cca70b99483e5a19ad787fe5a"
    sha256 cellar: :any_skip_relocation, sonoma:        "e5c204941f4a041e9b1fb627bacdf206f4d88c3430c215a2102cb93e1c839759"
    sha256 cellar: :any_skip_relocation, ventura:       "0671228f593bd78b4077439940ebce42247a70a7c61faaf54dd61f385ff68283"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2c65e3e624d853fcf1e563a4f4abbbff51a6ba2fab233249815e18873f0fcfeb"
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