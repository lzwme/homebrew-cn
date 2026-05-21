class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://ghfast.top/https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.98.2.tar.gz"
  sha256 "2b69fb5cc1ec7fa0ce9cc72fce6aa29f79e5d7cf874410da49301293abaeb17d"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3bcdde6dffad117f07a3a588b88dc8d60440571d421aacf2a7bae041b7d324ad"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4d39f741322187d74326a4b14e6eb74d4163585a9c49e9a8cc9d78dc363ae0ea"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ff2ea69a5501ec4e68f05c77a72247586ffce8487a00fe0c571f81591c3c6412"
    sha256 cellar: :any_skip_relocation, sonoma:        "d67b9cdac9d3e094e4d478304444675eeaf3b6109a8ee41ef6de87be67cd4fd5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7733f87c78b47034505ab87d52496bffad066dd3d8f04954824b1e9eeebcd32b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9c19e1005ba2522580d1fbdfe47d6e501d8f7d76e21d56f6b55e8e8c89f80052"
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