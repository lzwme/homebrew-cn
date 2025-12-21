class Lazysql < Formula
  desc "Cross-platform TUI database management tool"
  homepage "https://github.com/jorgerojas26/lazysql"
  url "https://ghfast.top/https://github.com/jorgerojas26/lazysql/archive/refs/tags/v0.4.5.tar.gz"
  sha256 "6c395c40c7400bfabbb5417feeed5fedbceb1058ba2971fe67c3a849f53d5a44"
  license "MIT"
  head "https://github.com/jorgerojas26/lazysql.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "20bf01108b398d5a84340ac0529395a19f266ea6119352e19ac4506175299662"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "20bf01108b398d5a84340ac0529395a19f266ea6119352e19ac4506175299662"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "20bf01108b398d5a84340ac0529395a19f266ea6119352e19ac4506175299662"
    sha256 cellar: :any_skip_relocation, sonoma:        "4b156b9506c8e66b26ab7c3541cece5b6b0dc1567a2dd4a149db6de22d785e71"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fdf322fa2836b5e6192f5aa554a492081ec0ede1208f302fd5a64d84bcf1cbdf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ca024c7d0ac405e95b3e8770353b4e4dd4e90eea7c62b1c8c800f595bb834d2d"
  end

  depends_on "go" => :build
  uses_from_macos "sqlite" => :test

  def install
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")
  end

  test do
    path = testpath/"school.sql"
    path.write <<~SQL
      create table students (name text, age integer);
      insert into students (name, age) values ('Bob', 14);
      insert into students (name, age) values ('Sue', 12);
      insert into students (name, age) values ('Tim', 13);
      select name from students order by age asc;
    SQL

    names = shell_output("sqlite3 test.db < #{path}").strip.split("\n")
    assert_equal %w[Sue Tim Bob], names

    assert_match "terminal not cursor addressable", shell_output("#{bin}/lazysql test.db 2>&1", 1)

    assert_match version.to_s, shell_output("#{bin}/lazysql -version 2>&1")
  end
end