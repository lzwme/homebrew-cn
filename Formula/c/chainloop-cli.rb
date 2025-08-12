class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://ghfast.top/https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.40.0.tar.gz"
  sha256 "2727601a05eafcb99546cccb794a2eda39e1ae645798fba3d32154cce39c9629"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c10524e8ea6c4faa2d2e4f2715f25347d4db0fefae96110c66b7eff5d9c6ee77"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bf50aa369734ca12f0b20155636dc57618809a7ac28e7ea40c43689d438af45b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "388eb84f947c9cd78dd809a406e5dc1633094b8142b0c7a61aac3032200588ff"
    sha256 cellar: :any_skip_relocation, sonoma:        "1547f2465c53a007684f7344e123aa019167cef08eb1e472c4bf274be72d67c6"
    sha256 cellar: :any_skip_relocation, ventura:       "fea94f7b777ed8113ebe5984c866fa5cf6541d1ec55700a010d0accef75c4524"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "74d88adb113708c59e18e622deadfd800360bb6dbe3ab89416601a3f4dab9a73"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/chainloop-dev/chainloop/app/cli/cmd.Version=#{version}
    ]

    system "go", "build", *std_go_args(ldflags:, output: bin/"chainloop"), "./app/cli"

    generate_completions_from_executable(bin/"chainloop", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/chainloop version 2>&1")

    output = shell_output("#{bin}/chainloop artifact download 2>&1", 1)
    assert_match "authentication required, please run \"chainloop auth login\"", output
  end
end