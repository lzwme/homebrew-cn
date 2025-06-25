class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https:docs.chainloop.dev"
  url "https:github.comchainloop-devchainlooparchiverefstagsv1.10.0.tar.gz"
  sha256 "4d5f843ce013a016a32efbc3f9180a5d72275428451b4240f2f720d4f660be76"
  license "Apache-2.0"
  head "https:github.comchainloop-devchainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d52aa5f3cd8e7d17b9e24956aca6b610cb508a3c5cd3c995fe4609fe968c68d9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f0e9d8a19cb1f3ef21c97663534fdd4b24251378b80e66c015ac141333c2b91b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a0ec5797fc6af2bc00715d621cf645502b562631e9f23a29ac940a6bd316a7d0"
    sha256 cellar: :any_skip_relocation, sonoma:        "5632d7f0939e530d5b83b4e495d80213842e8d7c90f72cdd2a5353923e839934"
    sha256 cellar: :any_skip_relocation, ventura:       "24c03d951c29e6fa8c9febcb0c7ca4e529142bb5797dd8cd6eeeb18301f2c13f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ccf760772817def97bf1bab69f48842e2c2e7b6a663445816507429c9a3caf65"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comchainloop-devchainloopappclicmd.Version=#{version}
    ]

    system "go", "build", *std_go_args(ldflags:, output: bin"chainloop"), ".appcli"

    generate_completions_from_executable(bin"chainloop", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}chainloop version 2>&1")

    output = shell_output("#{bin}chainloop artifact download 2>&1", 1)
    assert_match "authentication required, please run \"chainloop auth login\"", output
  end
end