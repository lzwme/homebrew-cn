class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://ghfast.top/https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.100.4.tar.gz"
  sha256 "53699475efb695a29c52575fa01a16066590305b6b4301773a48f31c86117353"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "36bb8c406fe03e590624a1c0d49734de869d43d4a2e71b369476241664223ffb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b760b20172c7cfae5a1a97259998aa62a5e7424ee3bd759b5d0c0a4d46620043"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "292e7df4a23c6f0990a2389ca5e70b34df191962b6a818315a17400080c02f36"
    sha256 cellar: :any_skip_relocation, sonoma:        "6c30072ef052a2ee8d2c71c78b7b4cd872564ba24d9c75274c1dfb8d8956e05e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b3f454f6988c45f4c9662a1a9a4c3c3234dcba3dcfcc250cdf9a4396701a934d"
    sha256 cellar: :any,                 x86_64_linux:  "378fd7b4bc3871e2612fea722a8b1e5c7f7b223891b4eb15faa90368be308365"
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