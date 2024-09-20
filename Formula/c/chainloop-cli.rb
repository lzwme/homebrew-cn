class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https:docs.chainloop.dev"
  url "https:github.comchainloop-devchainlooparchiverefstagsv0.96.11.tar.gz"
  sha256 "44b24c2989b07915e3ece92c37f9d221305a0558095608e26c893dff84c8161e"
  license "Apache-2.0"
  head "https:github.comchainloop-devchainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "830ac3423ed9be4784773594439ab58bfd179c7b998c2abc452485685b8f47d7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "830ac3423ed9be4784773594439ab58bfd179c7b998c2abc452485685b8f47d7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "830ac3423ed9be4784773594439ab58bfd179c7b998c2abc452485685b8f47d7"
    sha256 cellar: :any_skip_relocation, sonoma:        "3fbc10be5720669bd9bf9237fde1411b25172929fe7cf2858d9e7cba347cc708"
    sha256 cellar: :any_skip_relocation, ventura:       "5bf0e129777fe5aa54fc8e09368ef67611bb6dbb0e11225f75f9332fdf6d824a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "93363a1b6932f83b1e9a79a21cf7c99cdea5dee9e5c1ca77ee4dcd93c2645114"
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