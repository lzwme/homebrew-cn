class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https:docs.chainloop.dev"
  url "https:github.comchainloop-devchainlooparchiverefstagsv0.96.5.tar.gz"
  sha256 "7015cc1018725ed8de01054d0871c19361369c3c68e86e087f55adee4bd14e1f"
  license "Apache-2.0"
  head "https:github.comchainloop-devchainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "37349b9aa16989b096977c5f05f4fa8b0e189e53f4ce846919b55260034d2cf4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "37349b9aa16989b096977c5f05f4fa8b0e189e53f4ce846919b55260034d2cf4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "37349b9aa16989b096977c5f05f4fa8b0e189e53f4ce846919b55260034d2cf4"
    sha256 cellar: :any_skip_relocation, sonoma:         "e41dabf569605be279b0c0c48a8bcea6b4d266586ca6aa672c39337f654a255d"
    sha256 cellar: :any_skip_relocation, ventura:        "09b93732358d64310d30b60256d7c26563fcef57376f0e7de936d17c332eaa85"
    sha256 cellar: :any_skip_relocation, monterey:       "536cf05a9337f527c6a2288ec9dbf5118f5cfc1a1d2dba3e99ed0421e0bb8838"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c929f099e7146bbb2012ca9147cb6fccac1a15c8efe72379242e9e5a180586ab"
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