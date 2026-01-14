class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://ghfast.top/https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.71.0.tar.gz"
  sha256 "cebba41213b944ebd5c2f30f2383bef6becb399b89ba516bbf790722d8e3ab16"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0835c5a04a48c319a5cb0871d5de5a498bb78625f0a4975cba86f30852a87f9e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ba45b90aea10c42093d53c05da65eeccf5d681ad68451d14f9e5994ef3874d97"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3309d79a51264b85ac4937f3221d772374b17b1be68a1bc6090c5a6c0ee01cdb"
    sha256 cellar: :any_skip_relocation, sonoma:        "2cd516987222b9f30285896c120ffc873eb9cc557a387f975beaeb44ba023569"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0db32a0c0df1403f164f06d5b88f19a8433f328d302a6bce0b8d76a727b6a534"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "95ff2165740d7f8b25ee12d483c19e224489a1bc7b424e212b8ba035fde5dd95"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/chainloop-dev/chainloop/app/cli/cmd.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"chainloop"), "./app/cli"

    generate_completions_from_executable(bin/"chainloop", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/chainloop version 2>&1")

    output = shell_output("#{bin}/chainloop artifact download 2>&1", 1)
    assert_match "run chainloop auth login", output
  end
end