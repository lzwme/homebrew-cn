class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://ghfast.top/https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.37.1.tar.gz"
  sha256 "723b25f1e696ee1284cd23dfeeec39b8e28df7f06cc697171502a5932c1ec946"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "07615d041215e0ecae28ffdc81b1599fed808c8f045b0d563351a9d3ba6a68df"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "12abac15fb70571bd28b0b9bd8b97978e647e1051e9b70ed7d1b4cedaf4fbca3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "00d118fb685f889348426254c92858e691871e05b016982ba7f51f7d3f9ac158"
    sha256 cellar: :any_skip_relocation, sonoma:        "2c93b68977424dc56cd105497bd0c87808535c17f582d48f4d6d3147abef632a"
    sha256 cellar: :any_skip_relocation, ventura:       "a78a67f8acfd844e21c0ece44265da461e04c328665b078ff26ac50b899e1093"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d42969df8676e520d35b26b95e25b306cdecd5cfda8be4e25487b5ece1171337"
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