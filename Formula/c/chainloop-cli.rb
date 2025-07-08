class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://ghfast.top/https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.20.1.tar.gz"
  sha256 "c8fd97d423429cc69e6c2346ae336b9313653ace7f95812cd5e493acf7c97539"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "abcaf29d1ac856b1f132db85f51ae485b273393069bf9e49877d38e6169d70f6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1c627e74c8e3c521a3a6645410bf753f54bcaec8cfdd274faf01feedc2e9be78"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2c3fb956b769fe9d6dd5b17b12734c385f865b1eeccb1581663744dcd4ccb803"
    sha256 cellar: :any_skip_relocation, sonoma:        "e7420b17d45dffcf9f755d55e4fbd10fc0f0900b8d1f64e282dc5c6e619449bb"
    sha256 cellar: :any_skip_relocation, ventura:       "eef48dffdf09a724efd88762cfc0ab2bc7cadcc189d3427f9238f9aee97d401c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "88e1787903e73da45666b62795004fcfe4744e8034e04ce8a63a820cca6fcb75"
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