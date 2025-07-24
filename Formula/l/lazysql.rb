class Lazysql < Formula
  desc "Cross-platform TUI database management tool"
  homepage "https://github.com/jorgerojas26/lazysql"
  url "https://ghfast.top/https://github.com/jorgerojas26/lazysql/archive/refs/tags/v0.3.9.tar.gz"
  sha256 "2f3463200cb20e15b9db973c408af5d481a305be56597c97e65768537df4569e"
  license "MIT"
  head "https://github.com/jorgerojas26/lazysql.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c4ae34490787e033f81268214c4c201d331b4fa04760c052aa9be7128dbb515f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c4ae34490787e033f81268214c4c201d331b4fa04760c052aa9be7128dbb515f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c4ae34490787e033f81268214c4c201d331b4fa04760c052aa9be7128dbb515f"
    sha256 cellar: :any_skip_relocation, sonoma:        "5ed952984c89ea8990aaf0de7dc8de92bfcc7d57560c2f0caa8a3bffd0589ac6"
    sha256 cellar: :any_skip_relocation, ventura:       "5ed952984c89ea8990aaf0de7dc8de92bfcc7d57560c2f0caa8a3bffd0589ac6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "73c7bc76d1d1a5d167125eba0b8f39c0c41446291bcccad5fb62f4ef2ccf6e5a"
  end

  depends_on "go" => :build
  uses_from_macos "sqlite" => :test

  def install
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