class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://ghfast.top/https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.105.6.tar.gz"
  sha256 "04f37493d0f698ad0cf23c7b04d477a2ee5b93ab7ebe0f12276eb5b32cd07b77"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ff4aa3bf910d2909bbe7b742798fd2bdd2711928a65a0fc62f11af7b932fbfce"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ff4aa3bf910d2909bbe7b742798fd2bdd2711928a65a0fc62f11af7b932fbfce"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ff4aa3bf910d2909bbe7b742798fd2bdd2711928a65a0fc62f11af7b932fbfce"
    sha256 cellar: :any_skip_relocation, sonoma:        "e50bd7cfabcfa0531d85a828b515a945b3757cfa58db680b6f24b7c0417ca3c7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4648538a7ec274723686b41c54adc9b7036226deff29c04ca839ca2c032e4cc8"
    sha256 cellar: :any,                 x86_64_linux:  "a33af7d30cfcc6a4f8fd7e656169788723f88fe171dde93752c0f49e49e6aab5"
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