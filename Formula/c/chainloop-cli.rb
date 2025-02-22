class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https:docs.chainloop.dev"
  url "https:github.comchainloop-devchainlooparchiverefstagsv0.171.0.tar.gz"
  sha256 "59ac644c18729e99e641991d7ebd3c2a17bd49e8af1df2b6faef3263d72c51c7"
  license "Apache-2.0"
  head "https:github.comchainloop-devchainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8d8ff6c930b66a734dae58279bfb5addabab1f0eebcd4e6162d8fcdc6c3168de"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8d8ff6c930b66a734dae58279bfb5addabab1f0eebcd4e6162d8fcdc6c3168de"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8d8ff6c930b66a734dae58279bfb5addabab1f0eebcd4e6162d8fcdc6c3168de"
    sha256 cellar: :any_skip_relocation, sonoma:        "075132e391352b0e5aba4acd0253c27a8681ed1a8074e7833f22738bd833d935"
    sha256 cellar: :any_skip_relocation, ventura:       "f51358605e519dccafb798eccbbfccb819251099cb04bb5b8a496e7a09b11e85"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0a02ca02faace01c26c25011714f26761efadf575afdbc6388fab81e6866c3d6"
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