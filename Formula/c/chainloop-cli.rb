class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https:docs.chainloop.dev"
  url "https:github.comchainloop-devchainlooparchiverefstagsv0.94.2.tar.gz"
  sha256 "baf29b2f2d50b6ea6a2431d0fbc2e99e3175efaffcc79f43b8219b75b8e3f85d"
  license "Apache-2.0"
  head "https:github.comchainloop-devchainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "755c3db680adbd1368122bccbac80c8d052d4ed62d57b2a6449b2a3e2d65c8d3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e9814d5c5f80702624e2b22e0f3686b66aeccaed4063dd02f6256fc9d60cb4be"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "23ec8d86b4dc361c6a8802cac825ede1b0fe3b3f0d9bce394f090ea74c9187f6"
    sha256 cellar: :any_skip_relocation, sonoma:         "a9f88dfd4e47531a515cd66a20e2df05a2fbb487149a11e46a0fbd6a7b50fe4b"
    sha256 cellar: :any_skip_relocation, ventura:        "e38358c93d6d8c0f00b20d96eef92a072add416d21234d2530af21b4c3d3c2c4"
    sha256 cellar: :any_skip_relocation, monterey:       "8c574ba5c91a33aa1af7af2666fad64a374bbabd04d3c244ab158f3424c0e5d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a977cb116fc495d8a29ea0a474b95e60e2073f99dfd1c77b7744bce4953edd6a"
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