class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://ghfast.top/https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.54.0.tar.gz"
  sha256 "fb3424458d301714ac34b165765c5d7edb09e666f88a67da38bc92fa50a73910"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5672ec108a37c009743c4517cf9e53f6c855b035ec4e008eb48ce27fd2914c43"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "36821a122aae1e832d366d9f8eb7fbedff3c0bdbf91767abee16bd60a47287fc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "28706894a2407a5e0c3e40b4065feb2bb4ae7509aad8d91473171c62ea6e5010"
    sha256 cellar: :any_skip_relocation, sonoma:        "11f34de057af13aaf57d12014bfbfc641563bf046e9f59b4b91bfa470a4e2713"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f63fe60ccb224b6c50a9347d01d310c110a6645182f991afd0f93fecfa6abadd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "af76a8a27472391c0c8f30e2ed463cc8dab59b66379b409898397a0166e63b45"
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
    assert_match "run chainloop auth login", output
  end
end