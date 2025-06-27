class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https:docs.chainloop.dev"
  url "https:github.comchainloop-devchainlooparchiverefstagsv1.11.0.tar.gz"
  sha256 "b5c5112c416cfd4402375c41f6ae7e95e6a8859d31a3977ad8f125c0a4545bf0"
  license "Apache-2.0"
  head "https:github.comchainloop-devchainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "af959997722f2916d9577635da24053fae4097e16241ec41ca6c4e8b6659e1ee"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d01ae894343b24fd82d19d16ee9fe075af026a59d353a5bd317b7170fbe4462b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ba359b1abbbbbec9020933c8c45b8c8c63a93c6c62df7cfed11cd93116496cfd"
    sha256 cellar: :any_skip_relocation, sonoma:        "0efc360851c999ceaa03769e383e26e51a392eea787abd0c88f8351512f3f33c"
    sha256 cellar: :any_skip_relocation, ventura:       "d34355d59a3e39243efd97de4937764d0b20a41643b994d10b219b96d5142a79"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a7c517b8952f73cf3d8e41fdff10dcbf3f2460f2b471f7898f9de3f520736867"
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