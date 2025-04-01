class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https:docs.chainloop.dev"
  url "https:github.comchainloop-devchainlooparchiverefstagsv0.188.0.tar.gz"
  sha256 "5070851dc4bdfa57a7814ee56a301b09a91546d3d8bf5b5bdfa8335551bf5f26"
  license "Apache-2.0"
  head "https:github.comchainloop-devchainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "589caf69af9faaf7246837bfeed48d846ee8c8204ff48d26de667d760dfbd564"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "589caf69af9faaf7246837bfeed48d846ee8c8204ff48d26de667d760dfbd564"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "589caf69af9faaf7246837bfeed48d846ee8c8204ff48d26de667d760dfbd564"
    sha256 cellar: :any_skip_relocation, sonoma:        "6b41da9855bb38e0f8ac823c6a641ffddfcfc12f80bee91b234bcf9beb3ca81f"
    sha256 cellar: :any_skip_relocation, ventura:       "2fb9d193e611508f17c5bf87218f088c082b1e7ff7f102df21b1b4b04a102e17"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "da95026bef80e8dcb9bcb71031e80f660b83059264938fc1380cda8d98a42e26"
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