class Lazysql < Formula
  desc "Cross-platform TUI database management tool"
  homepage "https://github.com/jorgerojas26/lazysql"
  url "https://ghfast.top/https://github.com/jorgerojas26/lazysql/archive/refs/tags/v0.4.7.tar.gz"
  sha256 "7d0ebba0e9549b3f43d25358a6633e706ab3b1a410d323add7c7ef3397071f37"
  license "MIT"
  head "https://github.com/jorgerojas26/lazysql.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3436d97575b002a692d6692e3fc731e79970335b5c003b06c94f54a18856197a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3436d97575b002a692d6692e3fc731e79970335b5c003b06c94f54a18856197a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3436d97575b002a692d6692e3fc731e79970335b5c003b06c94f54a18856197a"
    sha256 cellar: :any_skip_relocation, sonoma:        "f06113baadd141d3b137dd93ff67262a831336884ce16dac5e5ea54cc8732c1b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "673f311d9d481fee1dcc51041bfb0e8b8e9600c920272b18a13afc20130010df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a0afa666e039117e7ddae18549d4d31e983102a832788f0e15d92064a2b0c861"
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