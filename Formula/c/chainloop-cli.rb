class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://ghfast.top/https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.35.0.tar.gz"
  sha256 "3b24e3ab1fb14d84e7e4d223dbbb8acb13f66a7a4c8e47337ea64630572a8c22"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4a4c8461b3e6d50497435d96729dce76ece503f5cb694116ade5e787dbf5b95e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "80c71e067a317ced935eecf48347c0f29b0d83a0141acdca112cc5f2178406b9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "211bad2131be2a154e8a97e53a7ddb61bd02f5fa442c105be046060132285b1b"
    sha256 cellar: :any_skip_relocation, sonoma:        "7507ea198c87936dc8fd55defd6e8688b5f7ccd7f2a11822847a3376ea5b37a6"
    sha256 cellar: :any_skip_relocation, ventura:       "314f182f7169e49cc1bb93cb0a88a85870f2797ee51aa5d2721996592a731240"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f2e4b59501d6c9b8142095a7b17eec3b9335d45e1fe3e9012254406c6b8ff141"
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