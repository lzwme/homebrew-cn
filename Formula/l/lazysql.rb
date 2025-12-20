class Lazysql < Formula
  desc "Cross-platform TUI database management tool"
  homepage "https://github.com/jorgerojas26/lazysql"
  url "https://ghfast.top/https://github.com/jorgerojas26/lazysql/archive/refs/tags/v0.4.4.tar.gz"
  sha256 "04929c9422a2c427f442ce7210804a2a48c82eaaf0870130009763c58f797270"
  license "MIT"
  head "https://github.com/jorgerojas26/lazysql.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fd00ea542f19114e7b66e21b4310759355b9558b5015214a81d28c66bc741d31"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fd00ea542f19114e7b66e21b4310759355b9558b5015214a81d28c66bc741d31"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fd00ea542f19114e7b66e21b4310759355b9558b5015214a81d28c66bc741d31"
    sha256 cellar: :any_skip_relocation, sonoma:        "337081a47c386a6fefe7e7e71dd8e78228d037de9b9e7778ee6b56084fc37268"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8d618f5c68461e8663c776fed8d29a68af9f8dccbbe7506f11efdb9b6c974c8c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b32a46a19917e23202b2205beebaceca90f56faf04929f0eae343453783a2437"
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