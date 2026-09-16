class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://ghfast.top/https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.109.4.tar.gz"
  sha256 "c25ca4774c9a18743b0858441160fba9112ffd5b40069558f1a14c01b2bd45db"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "fa5c97b285f2214571478de0893fd49da35c8cb3ea7c17c5475011a9725c0526"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "fa5c97b285f2214571478de0893fd49da35c8cb3ea7c17c5475011a9725c0526"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "fa5c97b285f2214571478de0893fd49da35c8cb3ea7c17c5475011a9725c0526"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "ca12489b2c622f7ee17dab553bdf1c41bc9880ef5ac0994f48a091fb5d889ff6"
    sha256 cellar: :any,                 x86_64_linux:      "13f18acabe7111e30565078593ba6d31eb18fe2fcf4e2284256b60e1650b7eb6"
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