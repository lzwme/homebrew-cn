class Anyquery < Formula
  desc "Query anything with SQL"
  homepage "https:anyquery.dev"
  url "https:github.comjulien040anyqueryarchiverefstags0.4.0.tar.gz"
  sha256 "bcadb61a2af9ae23f81ca55318d2b3f263cdd4012b4d136d16be3462e623c3e2"
  license "AGPL-3.0-only"
  head "https:github.comjulien040anyquery.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b5b6e24b8e94777dccc686edf15b2969d75c6aca82695ad1da949196693f8020"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f467fd2cf8d7f6f65b86b9f4f2bf8cce8030b9391fda28ddc49d07105ad70770"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9fd1f6bc159bdaba1c5b72aaf46acb641d3cadeef4b99c34a8245611d9563698"
    sha256 cellar: :any_skip_relocation, sonoma:        "6cd293246bffc75773851e498c7a4e0f3965230e9440706d3eea6cafcce68559"
    sha256 cellar: :any_skip_relocation, ventura:       "263847bc660b69f116e926987bf4a570688cd036b5fc5b15b129976af44b4777"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1f979906506f75715e4a8f47b77e1722c43b3d01891b31907db0d512a77b6a7f"
  end

  depends_on "go" => :build

  def install
    tags = %w[
      vtable
      fts5
      sqlite_json
      sqlite_math_functions
    ].join(",")
    system "go", "build", "-tags", tags, *std_go_args(ldflags: "-s -w")
    generate_completions_from_executable(bin"anyquery", "completion")
  end

  test do
    assert_match "no such table: non_existing_table",
                 shell_output("#{bin}anyquery -q \"SELECT * FROM non_existing_table\"")
    # test server
    pid = fork do
      system bin"anyquery", "server"
    end
    sleep 20
  ensure
    Process.kill("TERM", pid)
  end
end