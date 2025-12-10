class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://ghfast.top/https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.62.1.tar.gz"
  sha256 "0dfbedba19d53cfff339739361a2da2775b8a137094442c2399ac475dc260f40"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "43303120b47cf0abebee7bd906adf42f73f77d40951d6a92aca9faf93650ac42"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8f7303818dbc9586dddae67be3e27a88715187e944e2ac8983503168247cbc09"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "06b343f3f26b987f5d30920b32bf2a125d1f4148e3845046da8a95125cb0e214"
    sha256 cellar: :any_skip_relocation, sonoma:        "aa74b64b317fdee52441a35163b4bb38a7f7485d12152e3896a7a79a48adde5b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9c95e8a733ecaded6462073748cb7a2369fb475ef10db807fdcf1b9a986fb977"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "97fa4c394dcb4ba18bbc229220d8b67e9fdd82e736685e4f958a5790b7960603"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/chainloop-dev/chainloop/app/cli/cmd.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"chainloop"), "./app/cli"

    generate_completions_from_executable(bin/"chainloop", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/chainloop version 2>&1")

    output = shell_output("#{bin}/chainloop artifact download 2>&1", 1)
    assert_match "run chainloop auth login", output
  end
end