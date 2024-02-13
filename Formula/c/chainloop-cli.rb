class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https:docs.chainloop.dev"
  url "https:github.comchainloop-devchainlooparchiverefstagsv0.60.0.tar.gz"
  sha256 "9939eaa6fbca9f18175655ec688d64fbed93922554e572edec522e9c8ddc68a3"
  license "Apache-2.0"
  head "https:github.comchainloop-devchainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "19d86c976a941e172d7e2c1be2ad6897e98f30e487dfe009ce42b798805c2494"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0726bacf2ae52beaa06cab572b8026102ddd161445ae4ca377e926ae2d434479"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "58a0af0c4832aa13e5f2361dcaad42bf570d79aea58ac861be56e10b6acce60e"
    sha256 cellar: :any_skip_relocation, sonoma:         "2b2f669978b7063de96d3b0207d3777728d45857a857fab9c7c9edbffbcfdcb2"
    sha256 cellar: :any_skip_relocation, ventura:        "f26e1f6b449536f6461007947640f9cda026817c57c00f8279a61f677e71cc5e"
    sha256 cellar: :any_skip_relocation, monterey:       "4c4b927227c6e60388891a0e2703454f536ee29b2c4c380078ef94f73c82f940"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4a7aa9aa212e6e6327f652f571291fe452ad5735ac66842721af76227081a074"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comchainloop-devchainloopappclicmd.Version=#{version}
    ]

    system "go", "build", *std_go_args(output: bin"chainloop", ldflags: ldflags), ".appcli"

    generate_completions_from_executable(bin"chainloop", "completion", base_name: "chainloop")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}chainloop version 2>&1")

    output = shell_output("#{bin}chainloop artifact download 2>&1", 1)
    assert_match "authentication required, please run \"chainloop auth login\"", output
  end
end