class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://ghfast.top/https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.34.1.tar.gz"
  sha256 "d590131f75e0778437d429b2fea88218a80b29ccf8842c7ba96ea240daa8e48d"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "68ec005a6c38d05af8ac93d463cd2c42bf77acb00c994c86b90b025a9743ee8b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "be05a5d6cf96350ceb2b12c94fa05a2c09859aa90c74efde4430396544abfb43"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0fca25a59c0a9fa4a46ce42b2ffac39bce08673ff2953685b1b3a9ae71fa9653"
    sha256 cellar: :any_skip_relocation, sonoma:        "c1c6556506bd4cb8e9060694cef2fc77b270bcf03bd9dd2fbb49741e99e96e30"
    sha256 cellar: :any_skip_relocation, ventura:       "a86634067eaa131558f6b35fba3255ea3db49d3d83767a5ef161586b99036aa6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5c84e1629dc57dd7f5299cd578fead782d98c89fb9b9dc648b2d96f40c0799e4"
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