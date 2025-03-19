class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https:docs.chainloop.dev"
  url "https:github.comchainloop-devchainlooparchiverefstagsv0.183.0.tar.gz"
  sha256 "da61c5b0f09991de691ea7415058d4938d6549f4a98bf163c33938071646e6e3"
  license "Apache-2.0"
  head "https:github.comchainloop-devchainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c0453d5822e5632985040f96e1eea5748936b7efa62ac310f006364f632ec7f7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c0453d5822e5632985040f96e1eea5748936b7efa62ac310f006364f632ec7f7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c0453d5822e5632985040f96e1eea5748936b7efa62ac310f006364f632ec7f7"
    sha256 cellar: :any_skip_relocation, sonoma:        "8b49244128f9506bb181547b16da423e665ef290b30255a8651210f300cf0f6b"
    sha256 cellar: :any_skip_relocation, ventura:       "a7fe0060adf08a428c6617aed00b5265a084b411df2d5d354ec8607ddce72d68"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "98a28b0776fbf804bf479d2b2ae3fb73f79465966dc4db162c94e6a0aa0bcee9"
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