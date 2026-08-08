class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://ghfast.top/https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.105.7.tar.gz"
  sha256 "017bd5b61eeeab4d588722d4f00fbb4f7ce4b186af96ad590c50da859348d533"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "54d3877ec33ad68bebef8a7a036dbd5a6c424425bf1034aca60d7637fd83bf6c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "54d3877ec33ad68bebef8a7a036dbd5a6c424425bf1034aca60d7637fd83bf6c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "54d3877ec33ad68bebef8a7a036dbd5a6c424425bf1034aca60d7637fd83bf6c"
    sha256 cellar: :any_skip_relocation, sonoma:        "86f4dcc22db15ebd7c31eae672b63f7d69343fd0de9aebe7c7c2824f254548af"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "406343876c5de2f1dde4ce065a62f2bb5f486e5b3b17cd1d971b9181f0a97530"
    sha256 cellar: :any,                 x86_64_linux:  "1b526c98b65ef8f1527f591c652922c8e3994391322775472d96af2272d8e3fa"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
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