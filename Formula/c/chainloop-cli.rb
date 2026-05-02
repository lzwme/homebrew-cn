class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://ghfast.top/https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.95.1.tar.gz"
  sha256 "4e63db415968efae7f177bd8d6bdd92da3412fe481a388acca814cd3423ab2a7"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8f25822e70a3214d299e4b31116a8f80572c2af3c292774d73213fca165907b9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "13fde61ae6878a26e7b4404b15ceb6f8ccf6b93f75d1c14c77da055738607805"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "852f19dace49112f246d7e0e6951488b147ad6f18e7f0bdbaf5dda53681984e1"
    sha256 cellar: :any_skip_relocation, sonoma:        "5a4a92fa2422cf807822745e4d0fa030be527042e9c850a3a064ef6254d12ca1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "94bb3ec309a2c56909ed21136e662c7538ceb4a078ffbcf800b3de8d1842432b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "32e8fc9b3536c5421b4399c1607156eb5f6ce1ddb741014d63c7b359d8416a5f"
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