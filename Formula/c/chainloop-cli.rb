class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https:docs.chainloop.dev"
  url "https:github.comchainloop-devchainlooparchiverefstagsv0.161.0.tar.gz"
  sha256 "bf92e4c31b333eb419c3aa6b717b8fd091e82c8d49ec42d1787132c389acbd84"
  license "Apache-2.0"
  head "https:github.comchainloop-devchainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c9e81ae046ecbf2389b1903459f8f799d5af9a319692a2e51790d4f058245ae7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c9e81ae046ecbf2389b1903459f8f799d5af9a319692a2e51790d4f058245ae7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c9e81ae046ecbf2389b1903459f8f799d5af9a319692a2e51790d4f058245ae7"
    sha256 cellar: :any_skip_relocation, sonoma:        "e0fc8d9e69b1de5949707a77c1f6157e187760738835734062e1b532cdb9cc4e"
    sha256 cellar: :any_skip_relocation, ventura:       "a698d1fb582f9e7376d6686099d1f88b3ef7e9f2694b90bcec5794abeed4b0fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d01a648487f94ef81323e1fba2662d88b7a3f9a70bff2870113afe421061f775"
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