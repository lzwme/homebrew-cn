class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https:docs.chainloop.dev"
  url "https:github.comchainloop-devchainlooparchiverefstagsv0.174.0.tar.gz"
  sha256 "a6baa80f921056080cffd1e91410aab7edbd62751a392b695941f1fd20ab5da2"
  license "Apache-2.0"
  head "https:github.comchainloop-devchainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ed0c492a9c5c308e66dc5cf4b4099032642f1e808c3b9298d8c3f30095eae2c1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ed0c492a9c5c308e66dc5cf4b4099032642f1e808c3b9298d8c3f30095eae2c1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ed0c492a9c5c308e66dc5cf4b4099032642f1e808c3b9298d8c3f30095eae2c1"
    sha256 cellar: :any_skip_relocation, sonoma:        "9991ed528fe39f3f2dd72dfedd75cc9fef74d87ada15fde8d17a644e3c801ede"
    sha256 cellar: :any_skip_relocation, ventura:       "691fe3784cd12247bbb4549b16b2db37e3b2595ac513eb7f0a1f2fb90edfe888"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "78d169b133cd149ef6f505ed7619a56b12e0a720f10b13a20af388d9aae29d12"
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