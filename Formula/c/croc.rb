class Croc < Formula
  desc "Securely send things from one computer to another"
  homepage "https:github.comschollzcroc"
  url "https:github.comschollzcrocarchiverefstagsv9.6.11.tar.gz"
  sha256 "5bc56b184198f82d315c141c8e5d2fbd7e57bf2e84e92ee15e6dee99379cf490"
  license "MIT"
  head "https:github.comschollzcroc.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ceaaa8c0e8775feab5da76b33cb823ead0965d4fb4da58ed91842496b6d50bbf"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b75ae4037b694c686f06cf8e1acb5dd23c815e0c00742373f3239507afe69091"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c5eb3de44350452a468ba0a6e5fbbad6ef4fdae62d8afd77ad6e30d58b37d24d"
    sha256 cellar: :any_skip_relocation, sonoma:         "dcd039e6c255d3ececc96caabc6ef5d65e05514786c3e95dd255c2c252d3bd40"
    sha256 cellar: :any_skip_relocation, ventura:        "31780e39d8ec8d5268f7f13a896d65ca951789930c57c2c8b51f8d44567b9a4b"
    sha256 cellar: :any_skip_relocation, monterey:       "040596ebd0cdc11bf58c920c13d1280bdb8f3824ca3255c48cc62dbac064a60f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ed6bcad65094028a7ed010b27a35e17764603e4f4cae56e5309c1a070ae64a71"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    port=free_port

    fork do
      exec bin"croc", "relay", "--ports=#{port}"
    end
    sleep 1

    fork do
      exec bin"croc", "--relay=localhost:#{port}", "send", "--code=homebrew-test", "--text=mytext"
    end
    sleep 1

    assert_match shell_output("#{bin}croc --relay=localhost:#{port} --overwrite --yes homebrew-test").chomp, "mytext"
  end
end