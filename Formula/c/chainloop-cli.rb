class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https:docs.chainloop.dev"
  url "https:github.comchainloop-devchainlooparchiverefstagsv0.95.5.tar.gz"
  sha256 "45fe4f996974a53d41508ef39c6f0e004efa5c8c7f3647a18331ad58f9cd6b40"
  license "Apache-2.0"
  head "https:github.comchainloop-devchainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "70d12cde85f984aebe7d1d1c67d11433ba7103afde15a379f783cdfc05a74b1a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4b99f5d4e0cac96d60bbdc2370e7693d3c5c783233cacf250f88f601216089eb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f2fc08ceef1baa971256de962748a0d2e68ff43f4c792c1be864d5f772baa846"
    sha256 cellar: :any_skip_relocation, sonoma:         "7f58ccbcb02ffc064c95a756dde25f153e1f75648b6080af7ac2064d644c6b05"
    sha256 cellar: :any_skip_relocation, ventura:        "6cda5849547f780cd27c3f1d7afc3cd10af062798a5b2b14a9baba47d42028e7"
    sha256 cellar: :any_skip_relocation, monterey:       "6913eac80566f028e332a412bd460ea244f53509ff188b487d0e92e1243e0da4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "128a50e7d021a8e0daa39f8178df35ac550b161374735060895db0da4e5e7fa9"
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