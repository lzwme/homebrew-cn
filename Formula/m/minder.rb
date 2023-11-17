class Minder < Formula
  desc "CLI for interacting with Stacklok's Minder platform"
  homepage "https://minder-docs.stacklok.dev"
  url "https://ghproxy.com/https://github.com/stacklok/minder/archive/refs/tags/v0.0.17.tar.gz"
  sha256 "770b28767a1d8c8b0ef9c0ee00281d87d915525d3628196999cfdf2918d2581b"
  license "Apache-2.0"
  head "https://github.com/stacklok/minder.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "04b0ddd4a3befb5225169330231fca5bba3f1b91feaec365ce6cb2e0ce3a648f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d710e4ca5c414f89ab34736df62d0e9339ab2316e822fd57b551d80ba59c7ca8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "485c7c568915979756cde43f36b29494868221d5fc6356e59b515c042bcff313"
    sha256 cellar: :any_skip_relocation, sonoma:         "1a5bbf508266277d43a8bbffb6f705c66ec16d248b1eebb77b0301567aff70a2"
    sha256 cellar: :any_skip_relocation, ventura:        "1dc0fea7cdb1a001837478e8c8b386490153ae6a93c97a1097512342622acf71"
    sha256 cellar: :any_skip_relocation, monterey:       "5bf7b57485863f7bb0fe0c1db2b78350445058dd98e40a7fb3bef0fef5becd30"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "de5504a6ca2fbb34634c9b980c0dcb1da3cedc0bb297ceeb9058aabd9ff83e20"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/stacklok/minder/internal/constants.CLIVersion=#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/cli"

    generate_completions_from_executable(bin/"minder", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/minder version")

    output = shell_output("#{bin}/minder artifact list -p github 2>&1", 1)
    assert_match "Error on execute: error getting artifacts", output
  end
end