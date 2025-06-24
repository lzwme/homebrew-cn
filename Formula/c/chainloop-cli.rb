class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https:docs.chainloop.dev"
  url "https:github.comchainloop-devchainlooparchiverefstagsv1.9.0.tar.gz"
  sha256 "b2506c3b48d9bf7b6e813a4b307b0fd45289ce22d4474991c454c15afc3d63b2"
  license "Apache-2.0"
  head "https:github.comchainloop-devchainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8b95f14c059a1947f375eeddf4a1eacd9b45369068ee091b17b6dac0606fd63a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8859cca2b1386dacdce7524eadb8d4839ebd92d95b4a08c4fa714f30d724816b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a02e975403b49e278690c498939fac70a2da2e15aeb3f3f3b152616b4123d693"
    sha256 cellar: :any_skip_relocation, sonoma:        "201cf67cab6974ba94cabe235ee9f6456746495385ed8d98015f117dc318082f"
    sha256 cellar: :any_skip_relocation, ventura:       "89d805dfd3a888da07f5206e33c4c106c50e755151df406b6a4763ea95bc838d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "11be7808adb80a9b77620797d08df7ee78be6848ebf3cc34cb55f0b35fd2e326"
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