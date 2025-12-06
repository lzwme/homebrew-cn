class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://ghfast.top/https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.62.0.tar.gz"
  sha256 "e7b5a6ddf057d0bee46cc23b8e8aa3ebe60fe6a72f95984798c9987e4e3e7d34"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "70e5083f517b592e5eb7ecd301f0f9de518c27eb9d6926cdb3d872c8dd17b563"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ffada3757e197bcaaf230b6de2b0b185a36a60c8c6930ba1d148654a6dd9dd70"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d9aa0695a4e6124b89f8beb09c329fbfb11c3d8e00b7c1152499dd4c72b1e164"
    sha256 cellar: :any_skip_relocation, sonoma:        "8a189daa106593008fdf49bb036d6270fcb4c5460822f7df273acbc7db594cf4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2a8f67db2205ac8d2be8443a2441444af96e18e14dd9d55ae5ba751481d1926e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5d0a76ee2f8b0996f03291435c1647fd208257e888d692749a043d7008fff888"
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