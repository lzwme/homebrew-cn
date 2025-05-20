class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https:docs.chainloop.dev"
  url "https:github.comchainloop-devchainlooparchiverefstagsv1.4.0.tar.gz"
  sha256 "0494478436748766ec5d53400481458e5e96244ae61c3ebf9d91170c6a75c366"
  license "Apache-2.0"
  head "https:github.comchainloop-devchainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fe10b0a82bcc14b84f2fa2b5debeda93946644ae288f899d4d2b7c2a182466c6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d4679bf05c5d918b2602ccd27c548ba18bef2b96c01f2ca119aa5bdabc616ec0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "11a40692d7ce5cc6677cddaac7e47b0dc53fd382cc44995f3adbc2926261400f"
    sha256 cellar: :any_skip_relocation, sonoma:        "fc5423e897bd049157ae98e1d1ef96cddcd3ed343bf53348f949abd6181dddb8"
    sha256 cellar: :any_skip_relocation, ventura:       "d6f620230e2eee898d54ceb0d8ca09c5a3748bc97142173f6cfd71cb35c60661"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bbf5237eb09fdc1a15ac8ebdcd231de652a0ef7092adacc5ca8ac0ce348c4039"
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