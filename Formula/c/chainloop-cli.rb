class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https:docs.chainloop.dev"
  url "https:github.comchainloop-devchainlooparchiverefstagsv1.14.0.tar.gz"
  sha256 "a32f9ff720efad832b78901e85ea6e7f43334aa2620bf2a860e0938e9ed28c85"
  license "Apache-2.0"
  head "https:github.comchainloop-devchainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d27927651e145a42fd2c6546e08c8f1a33cc2617eac1c4aff9dd40cf2aba2296"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f7be43c7731b9a7b6ce8c1386f9da919aacf87b9e688afd093acac744106c1b9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "aa637286d393f6a03d097c142557a3e34fc61230ad02e820af910904fdf1c7e3"
    sha256 cellar: :any_skip_relocation, sonoma:        "18377d614582dc164f1dd2092fbfee44bab828f8f65a73dac7c74f497678bf29"
    sha256 cellar: :any_skip_relocation, ventura:       "773f3371408a59fd2ffb90ce1fb892b50257b3c6f06707a24ebca69714f90af1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c20020a1b631b237473cc50eb1e12d86d03ffd9fe37fde2626b73e696676ae70"
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