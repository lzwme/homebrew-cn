class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://ghfast.top/https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.102.0.tar.gz"
  sha256 "c6ed77ac903a632e8ceaf85e37f75617ee19f8762e925ce7b15c6331cd86ccf8"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7324aaf5d63e02f9d7df5a7e9a2412d13980371a4148eecdf8b4f8068503d6f6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7324aaf5d63e02f9d7df5a7e9a2412d13980371a4148eecdf8b4f8068503d6f6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7324aaf5d63e02f9d7df5a7e9a2412d13980371a4148eecdf8b4f8068503d6f6"
    sha256 cellar: :any_skip_relocation, sonoma:        "d710707f7db7e6071cee5dd091690dbde1fdf364f80ae383644da17de355d8fd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8a30dcafc75f04b1d4e160740004a4c0c664e5fdb50e98108601fe625022316e"
    sha256 cellar: :any,                 x86_64_linux:  "29358bd793ce5b38b2213a8bcaf36fe8c903406593ad4767ffe7443cafb13e53"
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