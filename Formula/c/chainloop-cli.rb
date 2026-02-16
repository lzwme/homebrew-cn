class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://ghfast.top/https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.76.1.tar.gz"
  sha256 "09c071e550dc2f85caffe73a222d883f414757d60737f2659c6eba2e0c5a2c31"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "41e65f75cdcb51049753554c4e2b29afbde5b3c8bf3d36259b477e7c59b866a2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eff688969faa03ca69b5974c2e3ffa2bc9533e2d0e7d9f2a9e7b2aaf99b201e8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4883274f2df59df49e424b13c51b6b8f530a2a5a705135454d9ca3ca83cc8b2c"
    sha256 cellar: :any_skip_relocation, sonoma:        "befcea8cffbc848c8501124eb6c6dcf6a2cf6c1a3829c6d4421e786c0b2c6141"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3fd331d6edf3e6aafea2742e87049c41bd333369c5c22d6d2aaab5630c057e87"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "89d03e0ac4326c0c21078e1f16c282ed5ba6e3a3d81adfb4c9744af605a114b3"
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