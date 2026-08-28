class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://ghfast.top/https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.107.3.tar.gz"
  sha256 "0145c7247d6e4edb4e09c142e4ada155ae3363d4021c23030dfad2744da82459"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3dd0accfaa4261e3c3a8bc03f74482390605655e21bf40c3d23d4963beaf697b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3dd0accfaa4261e3c3a8bc03f74482390605655e21bf40c3d23d4963beaf697b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3dd0accfaa4261e3c3a8bc03f74482390605655e21bf40c3d23d4963beaf697b"
    sha256 cellar: :any_skip_relocation, sonoma:        "fee05ee1f1c6d0e499b6cacd71fac8045bff710002729a659cf4668ed164da09"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "46f0b34f3b202db33d6d2df5eca03b3b76d4bcf7afabec411b644cce7ab9bc07"
    sha256 cellar: :any,                 x86_64_linux:  "5e5df5e11a20aa34a9b66f6b2de9a7dcc14f140d9630a08c7ca6a65f0db967d9"
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