class Micasa < Formula
  desc "TUI for tracking home projects, maintenance schedules, appliances and quotes"
  homepage "https://micasa.dev"
  url "https://ghfast.top/https://github.com/cpcloud/micasa/archive/refs/tags/v1.58.0.tar.gz"
  sha256 "1f05e978cde9ca9a03cb969b3f4b753b5fabba593cfcb0107145b31c4f431a7d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "11565a258d863ae235a7e0e8132bf2e6b3cf604f42b353954d70ef0fea496bbd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "11565a258d863ae235a7e0e8132bf2e6b3cf604f42b353954d70ef0fea496bbd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "11565a258d863ae235a7e0e8132bf2e6b3cf604f42b353954d70ef0fea496bbd"
    sha256 cellar: :any_skip_relocation, sonoma:        "e815ce84d07de4529ac5d7ffb952c2315ac11e8bfbde4b93ff4bccbc74e6d5d5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2aa160b1498262df820bfaaa11da4e1447653768f363ff651192929454fc4c6f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "190ff5bba06272dcd2e6d7135f728358988813a87d41f003b905629025caa2ad"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./cmd/micasa"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/micasa --version")

    # The program is a TUI so we need to spawn it and close the process after it creates the database file.
    pid = spawn(bin/"micasa", "--demo", testpath/"demo.db")
    sleep 3
    Process.kill("TERM", pid)
    Process.wait(pid)

    assert_path_exists testpath/"demo.db"
  end
end