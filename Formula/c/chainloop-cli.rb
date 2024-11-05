class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https:docs.chainloop.dev"
  url "https:github.comchainloop-devchainlooparchiverefstagsv0.97.7.tar.gz"
  sha256 "7ab1cb3803e70aa68f1bfd74be3184fa4db1d536bdf30cb6f83ef2c8ea059861"
  license "Apache-2.0"
  head "https:github.comchainloop-devchainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c9d2ad4609226666a66c46e5514ac8d49aaaef2a6b0566d8a5e58ea03f72fe44"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c9d2ad4609226666a66c46e5514ac8d49aaaef2a6b0566d8a5e58ea03f72fe44"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c9d2ad4609226666a66c46e5514ac8d49aaaef2a6b0566d8a5e58ea03f72fe44"
    sha256 cellar: :any_skip_relocation, sonoma:        "fef97df52353872ba7c9fb3e4864cf55fc7e8be63bcd479c0e7edcb79e9ff3da"
    sha256 cellar: :any_skip_relocation, ventura:       "fd25065e8c3ae20e58f2933973beb8686eb7dc4006e6e6d57c1cef6c1816e555"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "512bd6a507372deb77ea588e2b0fe1768a199bb53d61065227f8142f971c5f08"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comchainloop-devchainloopappclicmd.Version=#{version}
    ]

    system "go", "build", *std_go_args(ldflags:, output: bin"chainloop"), ".appcli"

    generate_completions_from_executable(bin"chainloop", "completion", base_name: "chainloop")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}chainloop version 2>&1")

    output = shell_output("#{bin}chainloop artifact download 2>&1", 1)
    assert_match "authentication required, please run \"chainloop auth login\"", output
  end
end