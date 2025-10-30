class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://ghfast.top/https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.50.1.tar.gz"
  sha256 "2ad1ff0c11d491cc150c0e70f09caf34585b2621f4445c6a393328359fe951b9"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e05354721f9fbc0588ad1532abb7f04bdcd39b6fabdc405519740516e1503b16"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "babb9ec70fe000f4afd0f8cc35d571987771f6050f75117fa44a068fb6e9fabd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b1a6e5b50c379895a2586a54472c867eaa0d4d52db16db51ceb4a4cff160bd6a"
    sha256 cellar: :any_skip_relocation, sonoma:        "a72cace94d886380c8b7617435e77b5614674c062d3aca271980fe993b4e75ca"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b8b55a78ed246653fa690c82988ed3d8c44a378a809533c598c5163d6087c454"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "99b9dd40ce3152b37acb226ff798159e036506eff4995ddb623f1fa907fe7189"
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