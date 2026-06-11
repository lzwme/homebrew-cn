class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://ghfast.top/https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.100.2.tar.gz"
  sha256 "8bd446a4aeda052abc9594a8ffa740f75c8c95b754be14cf78be3881d8cefcfe"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8915fa18b7157fedf27f099c81b179298583e71a3575f04f44d9c09b6a7137d4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a91484d4a2d02f7bea695cc69c1383babc01f1af1637049a217a9566c3e237a3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aa29ec74bb39830fc1727577a3ffe0ef5f6f016866f1a7eb44dc3cf17b750097"
    sha256 cellar: :any_skip_relocation, sonoma:        "c3176cf550157727b9fc50be11a810048386e47a805f62cb6b9e4223b5da3796"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2a9007aaafb7b9f4ebdf5e976a610663cde4c743035e23e8d5b457b9b947f9a0"
    sha256 cellar: :any,                 x86_64_linux:  "7beaabedc5dce1dc0d52f99a62404f713cbcc0426fef62c628b72d49d081a79e"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/chainloop-dev/chainloop/app/cli/cmd.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"chainloop"), "./app/cli"

    generate_completions_from_executable(bin/"chainloop", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/chainloop version 2>&1")

    output = shell_output("#{bin}/chainloop artifact download 2>&1", 1)
    assert_match "chainloop auth login", output
  end
end