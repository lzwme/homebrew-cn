class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https:docs.chainloop.dev"
  url "https:github.comchainloop-devchainlooparchiverefstagsv0.94.1.tar.gz"
  sha256 "7464d0ffbcb75275709629fb25ba56ebabd0b133cf8a7e8b2fff3dbd66dfe282"
  license "Apache-2.0"
  head "https:github.comchainloop-devchainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "63a293c6039b2e2e9b3263b88cb90460ee62f4a155fd4f2be133c6eb872fa7bb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0ce5f51d7713397396c9fa53fd38206352125cb0a1f49bc37274d4307dfac47d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "59e5d76cd9f7dbf62e27a0949c09b601dc75635976c4462dad2778a1a92ff760"
    sha256 cellar: :any_skip_relocation, sonoma:         "dccc4139597a0ee86487d73e56504aa21b46330f478b4e0df4767c56551d7c90"
    sha256 cellar: :any_skip_relocation, ventura:        "2cd2d34b24d9240db541cb504bcbba5aaa2f47328e4055f3788c1224df8d6ef2"
    sha256 cellar: :any_skip_relocation, monterey:       "34cff1a5e88ddc4d6526e5d0c046b7d62dc9e686c0dc1ab2229864b5bb5cf6c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b0f3f533d27227cf4bee113f8e6607471ebe54a0563246f0b064be05444ba9dc"
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