class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https:docs.chainloop.dev"
  url "https:github.comchainloop-devchainlooparchiverefstagsv0.83.0.tar.gz"
  sha256 "5120ebdae31ad0ed7d47ec4680abb413d8669221a743e6094818cb01929fa193"
  license "Apache-2.0"
  head "https:github.comchainloop-devchainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "49abbcc35686f533c56d9e7458867b14d44563b5d5d08cdca9ef01afc5b5e9a6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6e9623059eb9233a3743417a042759e3df2b4a674a0aacc5abff251411eb2198"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2cabf45a692cee1028878173a880bd3abed386328c688407e9c7e4d26de3f37b"
    sha256 cellar: :any_skip_relocation, sonoma:         "4b5aa1aaa913fc05d7b4ea62891c1a5600af15d29c389714240f9c7fbae418d3"
    sha256 cellar: :any_skip_relocation, ventura:        "e53bcead81e6954110757277c1286c2bc355c7787b3beeade3eef465965c855e"
    sha256 cellar: :any_skip_relocation, monterey:       "00ee058739385190945cb0fb1e797f4fcf3992015e10ed7722e66309813ba732"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8cd4e0a7e7aba6fd26f261b6d54624fc2a7456bbb27297668c899fb1bb9cbf45"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comchainloop-devchainloopappclicmd.Version=#{version}
    ]

    system "go", "build", *std_go_args(output: bin"chainloop", ldflags:), ".appcli"

    generate_completions_from_executable(bin"chainloop", "completion", base_name: "chainloop")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}chainloop version 2>&1")

    output = shell_output("#{bin}chainloop artifact download 2>&1", 1)
    assert_match "authentication required, please run \"chainloop auth login\"", output
  end
end