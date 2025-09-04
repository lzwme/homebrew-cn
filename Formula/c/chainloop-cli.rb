class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://ghfast.top/https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.43.3.tar.gz"
  sha256 "e449bc26f8e55a5d8f482f8f20e9f84a51d463017ca1e985c68e26fc158c4c65"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2874d741862bd225d55dc5d84b9f351f83f2d8f1fc59755b40d989604f025397"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f0c753fa972eb15b52a467a70fc8403ce49d9898e7b690fb67f9c70ed92cb375"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7a60e9f87b62097f7406c94cc90a04bd957a8fb7775d045c7404c0232d91bac1"
    sha256 cellar: :any_skip_relocation, sonoma:        "01add422874ba73dca88b42d7525a75fbd6d35faad758094940f369936abae47"
    sha256 cellar: :any_skip_relocation, ventura:       "408fa78366af4bcec79599d0bb1f4e80f9dc9ab53617d0d623240a0283a89f35"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2e87cf8df82083ee2e10e568b435e4cdcb2ad576d01820d119407834a5ac8a15"
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