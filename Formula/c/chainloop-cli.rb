class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https:docs.chainloop.dev"
  url "https:github.comchainloop-devchainlooparchiverefstagsv0.95.6.tar.gz"
  sha256 "bb89a4b03d675336e1b32442f447eaef9fdfd7af1b48a68300626f9680ac9135"
  license "Apache-2.0"
  head "https:github.comchainloop-devchainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6d7411804cee6e310ef8c5155b2eacd91c8c53a85bc9e84d36b3f6dbe2196100"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "48e67117b82d1eaaa4e75e761a183ca6db9388b43c4775db9c22f27196757180"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "810f2ccee8f54467fa2a1c38533e1e30d789cfc4c432ee441ecd7aea9b18ccfe"
    sha256 cellar: :any_skip_relocation, sonoma:         "a4f0ef80a169590cf66c5490d3d7791f30502da97a82f3a7325e1051a56d6a18"
    sha256 cellar: :any_skip_relocation, ventura:        "d033e327a9f8d3f0ad094bd76f1966f10404c71213d1e54df0eb55a1413fcdb8"
    sha256 cellar: :any_skip_relocation, monterey:       "754dde1d3cb5a8a720018e9ad25d45ceb9ee6195831221b528e1147283a8db85"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e2380095ed26673a7ec61825d5487ed965b314ff9ca113d7e027965837779371"
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