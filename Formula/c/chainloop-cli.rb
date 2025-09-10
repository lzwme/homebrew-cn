class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://ghfast.top/https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.45.0.tar.gz"
  sha256 "eca044f6eca37361c1d74f07f8f7df9d18fefd820559de268d960992f2db1342"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8d6cb9ce7459ebb739e0a8abcfa75c5e8e4289e1e68f5382243bce3b7701f76c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e415504c5701bbf39b72189e7572f3bb1f46da1da0f57c86c6ed7124a26a01b4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4fa9d104f955fd1444311bf9947d5d88cdac37fe1755e5f42c443314d00be0d0"
    sha256 cellar: :any_skip_relocation, sonoma:        "deb4821083b2aa3fea49e4dc661ba64b449e8acc7515d8abf6349db5c86b23fc"
    sha256 cellar: :any_skip_relocation, ventura:       "185c9689fc5f1e960344a0bec770bb5f0cff0cbfdaff83de081f9b3d14ef96b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "12866f0c0a880aaad535bdd2f8653799c37b234080cd4fe0711ab4fed6674c76"
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
    assert_match "authentication required, please run \"chainloop auth login\"", output
  end
end