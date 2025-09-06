class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://ghfast.top/https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.44.0.tar.gz"
  sha256 "8a483783c3e9615f6714aebb7a9274c0a1baf62b20b837cded206c57edabb552"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "783ee42e1abd83ad785b79fc8d7a149677ced4afa8e06b28f21a12e2a91e2f6d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8fbbc1020756391e39c2179e270e781c8f7ad084356608014c0c81854741cb02"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "37e2e1a2276ac553b075009407f7c3c092e9390f419ab20b2bea1e11a05406f9"
    sha256 cellar: :any_skip_relocation, sonoma:        "a2488bfac412c1147eb425f41757690ba58c500ed34251742b8c1c2f3ab72bdf"
    sha256 cellar: :any_skip_relocation, ventura:       "f040186a02ede248b35f7d3faddcf95d203f01233a5553fc6b7dd1f85ea28726"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "36804abd7e3275b017b78f45ca559504a43a52c6011c0c73bcf3f5b4048432fe"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/chainloop-dev/chainloop/app/cli/cmd.Version=#{version}
    ]

    system "go", "build", *std_go_args(ldflags:, output: bin/"chainloop"), "./app/cli"

    generate_completions_from_executable(bin/"chainloop", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/chainloop version 2>&1")

    output = shell_output("#{bin}/chainloop artifact download 2>&1", 1)
    assert_match "authentication required, please run \"chainloop auth login\"", output
  end
end