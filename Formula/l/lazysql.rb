class Lazysql < Formula
  desc "Cross-platform TUI database management tool"
  homepage "https://github.com/jorgerojas26/lazysql"
  url "https://ghfast.top/https://github.com/jorgerojas26/lazysql/archive/refs/tags/v0.5.2.tar.gz"
  sha256 "2e5baeda2d805a2efd8df65d9803087e8a3cb57f1cc205b2400f0d3240535040"
  license "MIT"
  head "https://github.com/jorgerojas26/lazysql.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ff82fbe529e5b162786828b30fc348eee32762a284644c9a53b58d1e8273b8b2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ff82fbe529e5b162786828b30fc348eee32762a284644c9a53b58d1e8273b8b2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ff82fbe529e5b162786828b30fc348eee32762a284644c9a53b58d1e8273b8b2"
    sha256 cellar: :any_skip_relocation, sonoma:        "c212f3ab339581f9516704547a65aa3f9ead6a39a887a0f7dd1b8886ac7dd49c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "577df8042c73f5a629b29592bd0a23c9ec0420c8d62cd9f3425b58913041c6c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a9f2c584a07f67665c4c14d7680ff3950e997411c6f99d8a1f91407ee03811c5"
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