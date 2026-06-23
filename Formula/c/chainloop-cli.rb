class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://ghfast.top/https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.100.13.tar.gz"
  sha256 "e5808909d83245177bf217dbf2f8069ea0a1cb11e500371b4bfb423cd7209212"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "95005fa65409831ef65c5f1bff4875c998a0b2e8f7e18b8552145ff735fde7fc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "95005fa65409831ef65c5f1bff4875c998a0b2e8f7e18b8552145ff735fde7fc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "95005fa65409831ef65c5f1bff4875c998a0b2e8f7e18b8552145ff735fde7fc"
    sha256 cellar: :any_skip_relocation, sonoma:        "d4d6dd3c058ca15e8ad3daf5c7c6a41703411b1941602f9349e89a3598cff05e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6a9654e57eb5d5823a258ce563eea41e89dba7c6e680adc57e427771e5ddf19d"
    sha256 cellar: :any,                 x86_64_linux:  "93fb22b897171e1cccb374b76899fae4679534e1cf4e750364a03ff4f23fd571"
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
    assert_match "chainloop auth login", output
  end
end